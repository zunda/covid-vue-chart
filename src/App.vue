<template>
  <div id="app">
    <h1>COVID-19 cases</h1>
    <TimeseriesPlot/>
    <RangeController/>
    <RegionSelector/>
  </div>
</template>

<script>
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import TimeseriesPlot from './components/TimeseriesPlot.vue'
import RangeController from './components/RangeController.vue'
import RegionSelector from './components/RegionSelector.vue'

const store = new Vuex.Store({
  state: {
    regions: [],
    duration: undefined,
    range: undefined
  },
  mutations: {
    setRegions: function(state, regions) {
      state.regions = regions
      updateLocation(state)
    },
    setRange: function(state, range) {
      state.range = range
      state.duration = undefined
      updateLocation(state)
    },
    setDuration: function(state, duration) {
      state.range = undefined
      state.duration = duration
      updateLocation(state)
    }
  },
})

function _pad(number) {
  if (number < 10) {
    return '0' + number
  } else {
    return '' + number
  }
}

function updateLocation(state) {
  let pars = []
  if (state.regions.length > 0) {
    pars.push("r=" + state.regions.join("-").replace(/ /g, "+"))
  }
  if (state.range != undefined) {
    let min = new Date(state.range.min)
    let max = new Date(state.range.max)
    pars.push("t=" +
      min.getUTCFullYear() +
      _pad(min.getUTCMonth() + 1) +
      _pad(min.getUTCDate()) +
      "-" +
      max.getUTCFullYear() +
      _pad(max.getUTCMonth() + 1) +
      _pad(max.getUTCDate()))
  } else if (state.duration != undefined) {
    pars.push("t=" + state.duration / (24 * 3600 * 1000))
  }
  let q = ''
  if (pars.length > 0) {
    q = '?' + pars.join("&")
  }
  history.replaceState(null, null, q)
}

function parseLocation() {
  let q = new URLSearchParams(location.search)
  let res = {
    regions: q.getAll("r").map(x => x.split("-")).flat().filter(x => x.length > 0),
    duration: undefined
  }
  let t = q.get("t")
  if (t != undefined) {
    let a = t.split("-").filter(x => x.length === 8)
    if (a.length === 2) {
      // t=yyyymmdd-yyyymmdd
      let min = a[0].match(/(\d{4,4})(\d\d)(\d\d)/)
      let max = a[1].match(/(\d{4,4})(\d\d)(\d\d)/)
      if (min != null && max != null) {
        res.range = {
          min: Date.UTC(min[1], parseInt(min[2]) - 1, min[3]),
          max: Date.UTC(max[1], parseInt(max[2]) - 1, max[3])
        }
      }
    } else {
      // t=-ddd
      let x = parseFloat(t)
      if (!isNaN(x)) {
        res.duration = x * 24 * 3600 * 1000
      }
    }
  }
  return res
}

export default {
  name: 'App',
  store,
  components: {
    TimeseriesPlot,
    RegionSelector,
    RangeController
  },
  mounted: function() {
    let q = parseLocation()
    if (q.regions.length > 0) {
      store.commit('setRegions',  q.regions)
    } else {
      store.commit('setRegions',  ['World'])
    }
    if (q.range != undefined) {
      store.commit('setRange', q.range)
    } else if (q.duration != undefined) {
      store.commit('setDuration', q.duration)
    }
  }
}
</script>

<style>
  h1 {
    font-size: 110%;
  }
  #app {
    font-family: sans-serif;
    text-align: center;
  }
</style>
