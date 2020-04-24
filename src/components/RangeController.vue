<template>
  <div class="chart-control">
    <input
      v-model="duration"
      placeholder="days" type="number" size="4" min="1" step="7"
    />
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
            this.$store.commit('setDuration',  -x * 24*3600*1000)
          }
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
