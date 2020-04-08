<template>
  <div class="chart">
    <line-chart :chartData="chartData" :options="options"></line-chart>
  </div>
</template>

<script>
  import LineChart from './LineChart.js'
  import timeSeries from '../assets/timeSeries.json'

  export default {
    components: {
      LineChart
    },
    data: () => ({
      chartData: {
        datasets: timeSeries
      },
      options: {
        animation: false,
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
              displayFormats: {
                week: 'M/D'
              }
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
          point: {
            radius: 1
          }
        },
        legend: {
          position: 'right'
        }
      }
    }),
  }
</script>

<style>
  .chart {
    max-width: 600px;
    margin:  150px auto;
  }
</style>
