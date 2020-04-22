<template>
  <div id="app">
    <h1>COVID-19 cases</h1>
    <RegionSelector/>
  </div>
</template>

<script>
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import RegionSelector from './components/RegionSelector.vue'

const store = new Vuex.Store({
  state: {
    regions: [],
    duration: undefined
  },
  mutations: {
    setRegions: function(state, regions) {
      state.regions = regions
      updateLocation(state)
    },
    setDuration: function(state, duration) {
      state.duration = duration
      updateLocation(state)
    }
  },
})

function updateLocation(state) {
  let pars = []
  if (state.regions.length > 0) {
    pars.push("r=" + state.regions.join("-").replace(/ /g, "+"))
  }
  if (state.duration != undefined) {
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
    let x = parseFloat(t)
    if (!isNaN(x)) {
      res.duration = x * 24 * 3600 * 1000
    }
  }
  return res
}

export default {
  name: 'App',
  store,
  components: {
    RegionSelector
  },
  mounted: function() {
    let q = parseLocation()
    if (q.regions.length > 0) {
      store.commit('setRegions',  q.regions)
    } else {
      store.commit('setRegions',  ['World'])
    }
    store.commit('setDuration', q.duration)
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
