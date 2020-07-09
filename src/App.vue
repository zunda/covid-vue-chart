<template>
  <div id="app">
    <TimeseriesPlot/>
    <RangeController/>
    <RegionSelector/>
  </div>
</template>

<script>
import moment from 'moment-timezone'
moment.tz.setDefault('UTC');

import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import TimeseriesPlot from './components/TimeseriesPlot.vue'
import RangeController from './components/RangeController.vue'
import RegionSelector from './components/RegionSelector.vue'

const dataPoints = {
  cumulativeCases: {},
  newCases: {}
}

const store = new Vuex.Store({
  state: {
    regions: [],
    duration: undefined,
    tMin: undefined,
    tMax: undefined,
    dMin: undefined,
    dMax: undefined,
    cumulative: true,
    dataSets: []
  },
  mutations: {
    setRegions: function(state, regions) {
      state.regions = regions
      updateDataSets(state)
      updateLocation(state)
    },
    setRange: function(state, obj) {
      state.tMin = obj.min
      state.tMax = obj.max
      state.duration = undefined
      updateLocation(state)
    },
    setDuration: function(state, duration) {
      state.tMin = undefined
      state.tMax = undefined
      state.duration = duration
      updateLocation(state)
    },
    setCumulative: function(state, flag) {
      state.cumulative = flag
      updateDataSets(state)
      updateLocation(state)
    }
  },
})

function _pad(number) {
  const pad = number < 10 ? "0" : ""
  return `${pad}${number}`
}

function updateLocation(state) {
  const pars = []
  let title = 'COVID-19 ' + (state.cumulative ? '' : 'new ') + 'cases-'
  if (! state.cumulative) {
    pars.push("n=t")
  }
  if (state.regions.length > 0) {
    pars.push("r=" + state.regions.join("-").replace(/ /g, "+"))
    title += state.regions.map(r => {
      const a = r.split(/\//)
      return a[a.length - 1]
    }).join(',') + '-'
  }
  if (state.tMin != undefined) {
    const x = new Date(Math.round(state.tMin/(24*3600*1000))*24*3600*1000)
    const d1 = x.getUTCFullYear() + _pad(x.getUTCMonth()+1) + _pad(x.getUTCDate())
    let t = "t=" + d1 + "-"
    title += d1 + "-"
    if (state.tMax != undefined) {
      const y = new Date(Math.round(state.tMax/(24*3600*1000))*24*3600*1000)
      const d2 = y.getUTCFullYear() + _pad(y.getUTCMonth()+1) + _pad(y.getUTCDate())
      t += d2
      title += d2
    }
    pars.push(t)
  } else if (state.duration != undefined) {
    pars.push("t=" + state.duration / (24 * 3600 * 1000))
    title += Math.round(-state.duration / (24 * 3600 * 1000)) + "days"
  }
  history.replaceState(null, null, pars.length > 0 ? '?' + pars.join("&") : '')
  document.title = title
}

function parseLocation() {
  const q = new URLSearchParams(location.search)
  const res = {
    regions: q.getAll("r").map(x => x.split("-")).flat().filter(x => x.length > 0),
    tMin: undefined,
    tMax: undefined,
    duration: undefined
  }
  const t = q.get("t")
  if (t != undefined) {
    if (t[0] === "-") {
      // t=-ddd
      const x = parseFloat(t)
      if (!isNaN(x) && x < 10000) {
        res.duration = x * 24 * 3600 * 1000
      }
    } else {
      const a = t.split("-")
      // t=yyyymmdd-yyyymmdd
      const x = a[0] != undefined ? a[0].match(/(\d{4,4})(\d\d)(\d\d)/) : null
      const min = x != null ? Date.UTC(x[1], parseInt(x[2]) - 1, x[3]) : null
      if (min != null) res.tMin = min
      const y = a[1] != undefined ? a[1].match(/(\d{4,4})(\d\d)(\d\d)/) : null
      const max = y != null ? Date.UTC(y[1], parseInt(y[2]) - 1, y[3]) : null
      if (max != null) res.tMax = max
    }
  }
  res.cumulative = !(q.get("n") === 't')
  return res
}

function updateDataSets(state) {
  const ts = state.cumulative ? dataPoints.cumulativeCases : dataPoints.newCases
  const ds = state.regions.map(r => {
    if (ts[r] === undefined) {
      ts[r] = 'fetching'
      const src = (state.cumulative ? "./cumulativeCases/" : "./newCases/") + r + '.json'
      fetch(src).then(response => response.json()).then(
        data => {
          ts[r] = data
          updateDataSets(state)
        }
      ).catch(
        err => {
          ts[r] = err
        }
      )
      return {label: r, data: []}
    } else if (Array.isArray(ts[r])) {
      // we alreadh have the data
      return {label: r, data: ts[r]}
    } else {
      // wait for the async call to finish fetching the data
      return {label: r, data: []}
    }
  })
  state.dataSets = ds
  // Each data need to be sorted with timestamps
  state.dMin = Math.min(...
    ds.filter(d => Array.isArray(d.data) && d.data.length > 0).map(x => x.data[0].x)
  )
  state.dMax = Math.max(...
    ds.filter(d => Array.isArray(d.data) && d.data.length > 0).map(x => x.data[x.data.length - 1].x)
  )
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
    const q = parseLocation()
    if (q.regions.length > 0) {
      store.commit('setRegions',  q.regions)
    } else {
      store.commit('setRegions',  ['World'])
    }
    if (q.duration != undefined) {
      store.commit('setDuration', q.duration)
    } else {
      store.commit('setRange', {min: q.tMin, max: q.tMax})
    }
    store.commit('setCumulative', q.cumulative)
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
