<template>
  <div class="chart">
    <line-chart :chartData="chartData" :options="options" />
    <div id="footer">
      Data were refreshed around {{ timestamps.refreshed }}.
      Global and US data are from <a href="https://github.com/CSSEGISandData/COVID-19">CSSEGISandData/COVID-19</a> &copy; 2020 Johns Hopkins University, educational and academic research purposes only.
      Data for Japan are from <a href="https://github.com/kaz-ogiwara/covid19">kaz-ogiwara/covid19</a> &copy; TOYO KEIZAI ONLINE.
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
        var data = this.regions.map(r => ({label: r, data: timeSeries[r]}));
        return { datasets: data }
      }
    },
    data: function () {
      return {
        options: {
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
                parser: (x) => {
                  var ymd = x.match(/\d+/g);
                  return(new Date(Date.UTC(
                    parseInt(ymd[0], 10),
                    parseInt(ymd[1], 10) - 1,
                    parseInt(ymd[2], 10)
                  )));
                },
                unit: 'week',
                displayFormats: { week: 'M/D' }
              }
            }],
            yAxes: [{
              scaleLabel: {
                display: true,
                labelString: 'Cumulative confirmed'
              },
              type: 'logarithmic',
              ticks: {
                callback: (value) => {
                  let r = String(value)
                  if (r.charAt(0) == '1') {
                    return r
                  } else {
                    return null
                  }
                }
              }
            }]
          },
          elements: {
            point: { radius: 1 }
          },
          legend: {
            position: 'top'
          }
        },
        timestamps: timestamps
      }
    },
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
