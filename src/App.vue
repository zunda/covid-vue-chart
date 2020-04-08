<template>
  <div id="app">
    <LineChart/>
    <RegionSelector/>
  </div>
</template>

<script>
import LineChart from './components/LineChart.vue'
import RegionSelector from './components/RegionSelector.vue'

export default {
  name: 'App',
  components: {
    LineChart,
    RegionSelector
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
