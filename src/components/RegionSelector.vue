<template>
  <div>
    <treeselect
      v-model="value"
      :multiple="true"
      :flat="true"
      :sort-value-by="ORDER_SELECTED"
      :value-consists-of="ALL"
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
      options: regions
    })
  }
</script>
