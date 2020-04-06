<template>
  <div class="chart">
    <line-chart :chartData="chartData" :options="options"></line-chart>
  </div>
</template>

<script>
  import LineChart from './LineChart.js'

  export default {
    components: {
      LineChart
    },
    data: () => ({
      chartData: {
        datasets: [
          {
            label: 'Tokyo',
            fill: 'false',
            lineTension: 0,
            borderColor: 'black',
            data: [
              {x: '2020-01-24', y: 1},
              {x: '2020-01-25', y: 2},
              {x: '2020-01-30', y: 3},
              {x: '2020-02-13', y: 4},
              {x: '2020-02-14', y: 6},
              {x: '2020-02-15', y: 14},
              {x: '2020-02-16', y: 19},
              {x: '2020-02-18', y: 22},
              {x: '2020-02-19', y: 25},
              {x: '2020-02-21', y: 28},
              {x: '2020-02-22', y: 29},
              {x: '2020-02-24', y: 32},
              {x: '2020-02-26', y: 35},
              {x: '2020-02-27', y: 36},
              {x: '2020-02-29', y: 37},
              {x: '2020-03-01', y: 39},
              {x: '2020-03-03', y: 40},
              {x: '2020-03-04', y: 44},
              {x: '2020-03-05', y: 52},
              {x: '2020-03-06', y: 58},
              {x: '2020-03-07', y: 64},
              {x: '2020-03-10', y: 67},
              {x: '2020-03-11', y: 73},
              {x: '2020-03-12', y: 75},
              {x: '2020-03-13', y: 77},
              {x: '2020-03-14', y: 87},
              {x: '2020-03-15', y: 90},
              {x: '2020-03-17', y: 102},
              {x: '2020-03-18', y: 111},
              {x: '2020-03-19', y: 118},
              {x: '2020-03-20', y: 129},
              {x: '2020-03-21', y: 136},
              {x: '2020-03-22', y: 138},
              {x: '2020-03-23', y: 154},
              {x: '2020-03-24', y: 171},
              {x: '2020-03-25', y: 212},
              {x: '2020-03-26', y: 259},
              {x: '2020-03-27', y: 299},
              {x: '2020-03-28', y: 362},
              {x: '2020-03-29', y: 430},
              {x: '2020-03-30', y: 443},
              {x: '2020-03-31', y: 521},
              {x: '2020-04-01', y: 587},
              {x: '2020-04-02', y: 684},
              {x: '2020-04-03', y: 773},
              {x: '2020-04-04', y: 890},
              {x: '2020-04-05', y: 1033},
            ]
          }
        ]
      },
      options: {
        animation: false,
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
