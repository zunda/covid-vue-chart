<template>
  <div class="small">
    <line-chart :chartData="datacollection"></line-chart>
  </div>
</template>

<script>
  import LineChart from './LineChart.js'

  export default {
    components: {
      LineChart
    },
    data: () => ({
      datacollection: {
        labels: [1, 2, 3],
        datasets: [
          {
            label: 'Series 1',
            backgroundColor: '#f87979',
            data: [1, 0, 2]
          }
        ]
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
