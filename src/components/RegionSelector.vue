<template>
  <div>
    <treeselect
      v-model="value"
      :multiple="multiple"
      :flat="flat"
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
    data: () => ({
      value: null,
      multiple: true,
      flat: true,
      sortValueBy: "ORDER_SELECTED",
      valueConsistsOf: "ALL",
      options: regions
    })
  }
</script>
