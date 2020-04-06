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
        labels: ['2020-01-01', '', '2020-04-01'],
        datasets: [
          {
            label: 'Series 1',
            backgroundColor: '#f87979',
            data: [1, 0, 2]
          }
        ]
      },
      options: {
        legend: {
          display: false
        }
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
