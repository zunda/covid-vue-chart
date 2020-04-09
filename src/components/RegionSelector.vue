<template>
  <div>
    <LineChart :regions="value" />
    <treeselect
      v-model="value"
      :multiple="true"
      :flat="true"
      :sort-value-by="sortValueBy"
      :value-consists-of="valueConsistsOf"
      :options="options"
    />
  </div>
</template>

<script>
  import Treeselect from '@riophae/vue-treeselect'
  import '@riophae/vue-treeselect/dist/vue-treeselect.css'
  import regions from '../assets/regions.json'

  import LineChart from './LineChart.vue'

  export default {
    components: {
      Treeselect,
      LineChart
    },
    data: function () {
      return {
        value: ['World'],
        options: regions,
        sortValueBy: "ORDER_SELECTED",
        valueConsistsOf: "ALL"
      }
    }
  }
</script>

<style>
.vue-treeselect {
  margin: 1em;
}
</style>
