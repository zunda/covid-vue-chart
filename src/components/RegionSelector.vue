<template>
  <div>
    <treeselect
      v-model="value"
      :multiple="true"
      :flat="true"
      :searchable="false"
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

  export default {
    components: {
      Treeselect
    },
    computed: {
      value: {
        get() {
          return this.$store.state.regions
        },
        set(ary) {
          this.$store.commit('setRegions',  ary)
        }
      }
    },
    data: function () {
      return {
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
