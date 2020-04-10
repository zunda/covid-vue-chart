<template>
  <div id="app">
    <h1>Time series from COVID-19 cases</h1>
    <RegionSelector/>
    <div id="footer">
      Global and US data from <a href="https://github.com/CSSEGISandData/COVID-19">CSSEGISandData/COVID-19</a> &copy; 2020 Johns Hopkins University, educational and academic research purposes only.
      Data for Japan from <a href="https://github.com/kaz-ogiwara/covid19">kaz-ogiwara/covid19</a> &copy; TOYO KEIZAI ONLINE.
      Fork me at <a href="https://github.com/zunda/covid-vue-chart">zunda/covid-vue-chart</a>.
    </div>
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
#footer {
  margin: 1em;
  font-size: 75%;
  text-align: left;
}
#footer p {
  margin: 0.2em;
}
</style>
