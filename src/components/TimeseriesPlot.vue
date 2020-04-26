<template>
  <div class="chart">
    <LineChart :chartData="chartData" :options="options" />
    <div id="footer" v-html="footnote" />
  </div>
</template>

<script>
  import { isMobile } from 'mobile-device-detect'

  import LineChart from './LineChart.js'
  import timeSeries from '../assets/timeSeries.json'
  import footnote from '../assets/footnote.json'

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
        let ds = this.$store.state.regions.filter(r => timeSeries[r] != undefined).map(r => ({label: r, data: timeSeries[r]}))
        // Each data need to be sorted with timestamps
        let min = Math.min(...
          ds.map(x => x.data[0].x)
        )
        let max = Math.max(...
          ds.map(x => x.data[x.data.length - 1].x)
        )
        return { datasets: ds, timeMax: max, timeMin: min }
      },
      options: function () {
        let x0Ticks = {}
        let y0Ticks = {}
        if (this.$store.state.tMin != undefined || this.$store.state.tMax != undefined) {
          x0Ticks.min = this.$store.state.tMin
          x0Ticks.max = this.$store.state.tMax
        } else if (this.$store.state.duration != undefined && this.chartData.timeMax != undefined) {
          x0Ticks.min = this.chartData.timeMax + this.$store.state.duration
          x0Ticks.max = undefined
        }
        if (x0Ticks.min != undefined) {
          let p = (x0Ticks.max != undefined) ?
            this.chartData.datasets.map(x => x.data.filter(p => x0Ticks.max >= p.x && p.x >= x0Ticks.min).map(p => p.y)).flat() :
            this.chartData.datasets.map(x => x.data.filter(p => p.x >= x0Ticks.min).map(p => p.y)).flat()
          let min = Math.min(...p)
          let max = Math.max(...p)
          let mergin = Math.pow(max/min, 0.05)
          y0Ticks = {min: min/mergin, max: max*mergin}
        }
        let d = (
          ((x0Ticks.max != undefined) ? x0Ticks.max : this.chartData.timeMax) -
          ((x0Ticks.min != undefined) ? x0Ticks.min : this.chartData.timeMin)
        ) / ( 24*3600*1000 )
        let xUnit = 'month'
        if (d < 1.5) {
          xUnit = 'hour'
        } else if (d < 11) {
          xUnit = 'day'
        } else if (d < 180) {
          xUnit = 'week'
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
                labelString: '2020'
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
                labelString: 'Cumulative confirmed'
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
          legend: {
            position: 'top'
          },
          plugins: {
            zoom: {
              pan: {
                enabled: isMobile,
                mode: 'x',
                onPanComplete: function({chart}) {
                  chart.options.refreshRange(
                    chart.scales['x-axis-0'].min,
                    chart.scales['x-axis-0'].max
                  )
                }
              },
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
            let doRefreshRange = () => {
              this.timerId = undefined
              let x1 = Math.floor(min / (24*3600*1000)) * (24*3600*1000)
              let x2 = Math.ceil(max / (24*3600*1000)) * (24*3600*1000)
              this.$store.commit('setRange', {min: x1, max: x2})
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
