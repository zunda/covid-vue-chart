<template>
  <div id="app">
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
#app {
  font-family: sans-serif;
  text-align: center;
  margin-top: 1em;
}
</style>
