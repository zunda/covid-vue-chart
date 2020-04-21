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
      history.replaceState(null, null, "?r=" + regions.join("-").replace(/ /g, "+"));
      state.regions = regions
    }
  }
})

export default {
  name: 'App',
  store,
  components: {
    RegionSelector
  },
  mounted: function() {
    var q = new URLSearchParams(location.search).getAll("r").map(x => x.split("-")).flat().filter(x => x.length > 0)
    if (q.length > 0) {
      store.commit('setRegions',  q)
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
