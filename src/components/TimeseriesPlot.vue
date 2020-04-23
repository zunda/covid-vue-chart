<template>
  <div class="chart">
    <LineChart :chartData="chartData" :options="options" />
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
  import LineChart from './LineChart.js'
  import timeSeries from '../assets/timeSeries.json'
  import timestamps from '../assets/timestamps.json'

  export default {
    components: {
      LineChart
    },
    props: {
      regions: Array
    },
    computed: {
      chartData: function() {
        let ds = this.regions.filter(r => timeSeries[r] != undefined).map(r => ({label: r, data: timeSeries[r]}))
        let max = Math.max(...
          ds.map(x => x.data[x.data.length - 1].x)
        )
        let min = Math.min(...
          ds.map(x => x.data[0].x)
        )
        return { datasets: ds, timeMax: max, timeMin: min }
      },
      options: function () {
        let x0Ticks = {}
        let y0Ticks = {}
        if (this.$store.state.duration != undefined && this.chartData.timeMax != undefined) {
          x0Ticks.min = this.chartData.timeMax + this.$store.state.duration
          let p = this.chartData.datasets.map(x => x.data.filter(p => p.x > x0Ticks.min).map(p => p.y)).flat()
          let min = Math.min(...p)
          let max = Math.max(...p)
          let mergin = Math.pow(max/min, 0.05)
          y0Ticks = {min: min/mergin, max: max*mergin}
        }
        let d = ((this.$store.state.duration != undefined)
          ? -this.$store.state.duration
          : (this.chartData.timeMax - this.chartData.timeMin)
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
              zoom: {
                enabled: true,
                drag: true,
                mode: 'x',
                speed: 0
              }
            }
          }
        }
      },
      timestamps: function() {
        return timestamps
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
    text-align: left;
    color: gray;
  }
  #footer p {
    margin: 0.2em;
  }
</style>
