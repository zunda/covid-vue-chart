<template>
  <div id="app">
    <h1>COVID-19 cases</h1>
    <RegionSelector/>
  </div>
</template>

<script>
import RegionSelector from './components/RegionSelector.vue'

export default {
  name: 'App',
  components: {
    RegionSelector
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
