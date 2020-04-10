<template>
  <div>
    <LineChart :regions="value" />
    <treeselect
      v-model="value"
      :multiple="true"
      :flat="true"
      :searchable="false"
      :sort-value-by="sortValueBy"
      :value-consists-of="valueConsistsOf"
      :options="options"
      @input="updateQuery"
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
        value: [],
        options: regions,
        sortValueBy: "ORDER_SELECTED",
        valueConsistsOf: "ALL"
      }
    },
    mounted: function () {
      var q = new URLSearchParams(location.search).getAll("r").map(x => x.split("-")).flat().filter(x => x.length > 0);
      if (q.length > 0) {
        this.value = q;
      } else {
        this.value = ['World'];
      }
    },
    methods: {
      updateQuery: function (value) {
        history.replaceState(null, null, "?r=" + value.join("-").replace(/ /g, "+"));
      }
    }
  }
</script>

<style>
.vue-treeselect {
  margin: 1em;
}
</style>
