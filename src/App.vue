<template>
  <div id="app">
    <RandomChart/>
  </div>
</template>

<script>
import RandomChart from './components/RandomChart.vue'

export default {
  name: 'App',
  components: {
    RandomChart
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
