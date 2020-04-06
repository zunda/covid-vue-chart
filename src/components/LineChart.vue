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
              {x: '2020-01-24T00:00Z', y: 1},
              {x: '2020-01-25T00:00Z', y: 2},
              {x: '2020-01-30T00:00Z', y: 3},
              {x: '2020-02-13T00:00Z', y: 4},
              {x: '2020-02-14T00:00Z', y: 6},
              {x: '2020-02-15T00:00Z', y: 14},
              {x: '2020-02-16T00:00Z', y: 19},
              {x: '2020-02-18T00:00Z', y: 22},
              {x: '2020-02-19T00:00Z', y: 25},
              {x: '2020-02-21T00:00Z', y: 28},
              {x: '2020-02-22T00:00Z', y: 29},
              {x: '2020-02-24T00:00Z', y: 32},
              {x: '2020-02-26T00:00Z', y: 35},
              {x: '2020-02-27T00:00Z', y: 36},
              {x: '2020-02-29T00:00Z', y: 37},
              {x: '2020-03-01T00:00Z', y: 39},
              {x: '2020-03-03T00:00Z', y: 40},
              {x: '2020-03-04T00:00Z', y: 44},
              {x: '2020-03-05T00:00Z', y: 52},
              {x: '2020-03-06T00:00Z', y: 58},
              {x: '2020-03-07T00:00Z', y: 64},
              {x: '2020-03-10T00:00Z', y: 67},
              {x: '2020-03-11T00:00Z', y: 73},
              {x: '2020-03-12T00:00Z', y: 75},
              {x: '2020-03-13T00:00Z', y: 77},
              {x: '2020-03-14T00:00Z', y: 87},
              {x: '2020-03-15T00:00Z', y: 90},
              {x: '2020-03-17T00:00Z', y: 102},
              {x: '2020-03-18T00:00Z', y: 111},
              {x: '2020-03-19T00:00Z', y: 118},
              {x: '2020-03-20T00:00Z', y: 129},
              {x: '2020-03-21T00:00Z', y: 136},
              {x: '2020-03-22T00:00Z', y: 138},
              {x: '2020-03-23T00:00Z', y: 154},
              {x: '2020-03-24T00:00Z', y: 171},
              {x: '2020-03-25T00:00Z', y: 212},
              {x: '2020-03-26T00:00Z', y: 259},
              {x: '2020-03-27T00:00Z', y: 299},
              {x: '2020-03-28T00:00Z', y: 362},
              {x: '2020-03-29T00:00Z', y: 430},
              {x: '2020-03-30T00:00Z', y: 443},
              {x: '2020-03-31T00:00Z', y: 521},
              {x: '2020-04-01T00:00Z', y: 587},
              {x: '2020-04-02T00:00Z', y: 684},
              {x: '2020-04-03T00:00Z', y: 773},
              {x: '2020-04-04T00:00Z', y: 890},
              {x: '2020-04-05T00:00Z', y: 1033},
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
              unit: 'week',
              displayFormats: {
                week: 'M/DD'
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
