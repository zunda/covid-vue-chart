<template>
  <div class="small">
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
            label: 'Series 1',
            backgroundColor: '#f87979',
            data: [
              {x: new Date(2020, 1, 1), y: 1},
              {x: new Date(2020, 2, 1), y: 0},
              {x: new Date(2020, 4, 1), y: 2},
            ]
          }
        ]
      },
      options: {
        scales: {
          xAxes: [{
            type: 'time'
          }]
        },
      }
    }),
  }
</script>

<style>
  .small {
    max-width: 600px;
    margin:  150px auto;
  }
</style>
