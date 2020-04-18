<template>
  <div id="chart">
    <ejs-chart id="container" :primaryXAxis="primaryXAxis" :primaryYAxis="primaryYAxis" :legendSettings="legendSettings" :tooltip="tooltip" :zoomSettings="zoom">
      <e-series-collection>
        <e-series v-for="s in dataSets" :dataSource=s.dataSource :name=s.name :key=s.name type="Line" xName="x" yName="y" :marker='marker' />
      </e-series-collection>
    </ejs-chart>
    <div id="footer">
      Data were refreshed around {{ timestamps.refreshed }}.
      Global and US data are from <a href="https://github.com/CSSEGISandData/COVID-19">CSSEGISandData/COVID-19</a> &copy; 2020 Johns Hopkins University, educational and academic research purposes only.
      Data for Japan are from <a href="https://github.com/kaz-ogiwara/covid19">kaz-ogiwara/covid19</a> &copy; TOYO KEIZAI ONLINE.
      Data for Tokyo are from <a href="https://stopcovid19.metro.tokyo.lg.jp/">stopcovid19.metro.tokyo.lg.jp</a> &copy; 2020 Tokyo Metropolitan Government.
      Fork me at <a href="https://github.com/zunda/covid-vue-chart">zunda/covid-vue-chart</a>.
    </div>
  </div>
</template>

<script>
  import Vue from 'vue'
  import { ChartPlugin, LineSeries, Logarithmic, DateTime, Legend, Tooltip, Zoom } from '@syncfusion/ej2-vue-charts'
  Vue.use(ChartPlugin)

  import timeSeries from '../assets/timeSeries.json'
  import timestamps from '../assets/timestamps.json'

  export default {
    provide: {
      chart: [LineSeries, Logarithmic, DateTime, Legend, Tooltip, Zoom]
    },
    props: {
      regions: Array
    },
    data: function() {
      return {
        primaryXAxis: {
          valueType: 'DateTime',
          title: 'Date',
        },
        primaryYAxis: {
          valueType: 'Logarithmic',
          title: 'Columutive confirmed'
        },
        marker: {
          visible: true,
          width: 1,
          height: 1
        },
        legendSettings: {
          visible: true,
          position: 'Top'
        },
        tooltip: {
          enable: true
        },
        zoom: {
          enablePinchZooming: true,
          enableSelectionZooming: true
        },
        title: 'COVID-19 cases'
      }
    },
    computed: {
      dataSets: function() {
        return this.regions.map(function(r) {
          if (timeSeries[r] !== undefined) {
            return {name: r, dataSource: timeSeries[r]}
          } else {
            return {}
          }
        })
      },
      timestamps: function() {
        return timestamps
      }
    }
  }
</script>

<style>
  #chart {
    max-width: 800px;
    width: 90%;
    margin: 0 auto;
  }
  #footer {
    margin: 1em;
    font-size: 75%;
    text-align: left;
    color: gray;
  }
  #footer p {
    margin: 0.2em;
  }
</style>
