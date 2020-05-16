<template>
  <div class="chart">
    <LineChart :chartData="chartData" :options="options" />
    <div id="footer" v-html="footnote" />
  </div>
</template>

<script>
  import { isMobile } from 'mobile-device-detect'

  import LineChart from './LineChart.js'
  import footnote from '../assets/footnote.json'

  function _pad(number) {
    const pad = number < 10 ? "0" : ""
    return `${pad}${number}`
  }

  export default {
    components: {
      LineChart
    },
    data: function() {
      return {
        timerId: undefined
      }
    },
    computed: {
      chartData: function() {
        return {
          datasets: this.$store.state.dataSets,
          timeMin: this.$store.state.dMin,
          timeMax: this.$store.state.dMax
        }
      },
      options: function () {
        const x0Ticks = {}
        const y0Ticks = {}
        if (this.$store.state.tMin != undefined || this.$store.state.tMax != undefined) {
          x0Ticks.min = this.$store.state.tMin
          x0Ticks.max = this.$store.state.tMax
        } else if (this.$store.state.duration != undefined && this.chartData.timeMax != undefined) {
          x0Ticks.min = this.chartData.timeMax + this.$store.state.duration
          x0Ticks.max = undefined
        }
        if (x0Ticks.min != undefined) {
          const p = (x0Ticks.max != undefined) ?
            this.chartData.datasets.map(x => x.data.filter(q => x0Ticks.max >= q.x && q.x >= x0Ticks.min).map(q => q.y)).flat() :
            this.chartData.datasets.map(x => x.data.filter(q => q.x >= x0Ticks.min).map(q => q.y)).flat()
          const min = Math.min(...p)
          const max = Math.max(...p)
          const mergin = Math.pow(max/min, 0.05)
          y0Ticks.min = min/mergin
          y0Ticks.max = max*mergin
        }
        const tMin = new Date(x0Ticks.min != undefined ? x0Ticks.min : this.chartData.timeMin)
        const tMax = new Date(x0Ticks.max != undefined ? x0Ticks.max : this.chartData.timeMax)
        const yearMin = tMin.getUTCFullYear()
        const yearMax = tMax.getUTCFullYear()
        let xLabel = yearMin === yearMax ? yearMax : yearMin + ' - ' + yearMax
        const d = (tMax - tMin)/( 24*3600*1000 )
        let xUnit = 'month'
        if (d < 1.5) {
          xUnit = 'hour'
          const dateMin = tMin.getUTCFullYear() + '/' + (tMin.getUTCMonth() + 1) + '/' + tMin.getUTCDate()
          const dateMax = tMax.getUTCFullYear() + '/' + (tMax.getUTCMonth() + 1) + '/' + tMax.getUTCDate()
          xLabel = dateMin === dateMax ? dateMax : dateMin + ' - ' + dateMax
        } else if (d < 11) {
          xUnit = 'day'
        } else if (d < 180) {
          xUnit = 'week'
        }
        const pan = isMobile ? {
          enabled: true,
          mode: 'x',
          onPanComplete: function({chart}) {
            chart.options.refreshRange(
              chart.scales['x-axis-0'].min,
              chart.scales['x-axis-0'].max
            )
          }
        } : {
          enabled: false
        }
        return {
          animation: false,
          maintainAspectRatio: true,
          datasets: {
            line: {
              fill: false,
              lineTension: 0
            }
          },
          scales: {
            xAxes: [{
              scaleLabel: {
                display: true,
                labelString: xLabel
              },
              type: 'time',
              time: {
                unit: xUnit,
                displayFormats: {
                  day: 'M/D',
                  week: 'M/D',
                  month: 'M/D'
                }
              },
              ticks: x0Ticks
            }],
            yAxes: [{
              scaleLabel: {
                display: true,
                labelString: this.$store.state.cumulative ? 'Cumulative confirmed COVID-19 cases' : 'Daily new COVID-19 cases, 7-day moving average'
              },
              type: 'logarithmic',
              ticks: {
                ...y0Ticks,
                callback: function (value, index, values) {
                  var r = value.toLocaleString();
                  if (r.match(/^[1-9][,0]*$/) === null) { return null }
                  var m = 1
                  if (values.length < 25) { m = 5 }
                  if (values.length < 14) { m = 9 }
                  if (parseInt(r.charAt(0)) > m) { return null }
                  return r
                }
              }
            }]
          },
          elements: {
            point: { radius: 1 }
          },
          tooltips: {
            callbacks: {
              label: function(item, data) {
                const region = data.datasets[item.datasetIndex].label
                let count = data.datasets[item.datasetIndex].data[item.index].y
                if (!Number.isInteger(count)) {
                  count = Math.round(count*10)/10
                }
                return region + ": " + count
              },
              title: function(item, data) {
                const x = new Date(data.datasets[item[0].datasetIndex].data[item[0].index].x)
                return x.getUTCFullYear() + "-" + _pad(x.getUTCMonth()+1) + "-" +  _pad(x.getUTCDate())
              }
            }
          },
          legend: {
            position: 'top'
          },
          plugins: {
            zoom: {
              pan: pan,
              zoom: {
                enabled: true,
                drag: true,
                mode: 'x',
                speed: 0,
                onZoomComplete: function({chart}) {
                  chart.options.refreshRange(
                    chart.scales['x-axis-0'].min,
                    chart.scales['x-axis-0'].max
                  )
                }
              }
            }
          },
          refreshRange: (min, max) => {
            if (this.timerId != undefined) {
              clearTimeout(this.timerId)
            }
            const doRefreshRange = () => {
              this.timerId = undefined
              this.$store.commit('setRange', {min: min, max: max})
            }
            if (isMobile) {
              this.timerId = setTimeout(doRefreshRange, 500)
            } else {
              doRefreshRange()
            }
          }
        }
      },
      footnote: function() {
        return footnote
      }
    }
  }
</script>

<style>
  .chart {
    width: 90%;
    max-width: 600px;
    margin: 0 auto;
  }
  #footer {
    margin: 1em;
    font-size: 75%;
    text-align: justify;
    color: gray;
  }
  #footer p {
    margin: 0.2em;
  }
</style>
