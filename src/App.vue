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
    regions: []
  },
  mutations: {
    setRegions: function(state, regions) {
      state.regions = regions
      updateLocation(state)
    }
  },
})

function updateLocation(state) {
  history.replaceState(null, null, "?r=" + state.regions.join("-").replace(/ /g, "+"));
}

function parseLocation() {
  let q = new URLSearchParams(location.search)
  let r = q.getAll("r").map(x => x.split("-")).flat().filter(x => x.length > 0)
  return {r: r}
}

export default {
  name: 'App',
  store,
  components: {
    RegionSelector
  },
  mounted: function() {
    let q = parseLocation()
    if (q.r.length > 0) {
      store.commit('setRegions',  q.r)
    } else {
      store.commit('setRegions',  ['World'])
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
