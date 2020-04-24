<template>
  <div class="chart-control">
    <input
      v-model="duration"
      placeholder="days" type="number" size="4" min="1"
    />
    <button v-on:click="resetZoom">Show all</button>
  </div>
</template>

<script>
  export default {
    computed: {
      duration: {
        get() {
          let x = this.$store.state.duration
          if (x != undefined && !isNaN(x)) {
            return -x / (24*3600*1000)
          } else {
            return ''
          }
        },
        set(duration) {
          let x = parseFloat(duration)
          if (!isNaN(x)) {
            this.$store.commit('setDuration',  -x * 24*3600*1000)
          } else {
            this.$store.commit('setDuration',  undefined)
          }
        }
      }
    },
    methods: {
      resetZoom: function() {
        this.$store.commit('setDuration',  undefined)
      }
    }
  }
</script>

<style>
.chart-control {
  margin: 1em;
  text-align: right;
}
</style>
