<template>
  <div class="chart-control">
    <input
      v-model="duration"
      placeholder="days" type="number" size="4" min="1"
    />
    <button :disabled="history.i == undefined || history.i == 0" v-on:click="goPrev()">Prev</button>
    <button :disabled="history.i == undefined || history.i == history.max" v-on:click="goNext()">Next</button>
    <button v-on:click="resetZoom">Show all</button>
  </div>
</template>

<script>
  export default {
    data: function() {
      return {
        history: {
          i: undefined,
          max: undefined,
          h: []
        },
        timerId: undefined
      }
    },
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
      },
      goPrev: function() {
        this.history.i--
        this.zoomTo()
      },
      goNext: function() {
        this.history.i++
        this.zoomTo()
      },
      zoomTo: function() {
        let i = this.history.i
        if (this.history.h[i].duration != undefined) {
          this.$store.commit('setDuration',  this.history.h[i].duration)
        } else {
          this.$store.commit('setRange',  {
            min: this.history.h[i].min,
            max: this.history.h[i].max
          })
        }
      }
    },
    mounted: function() {
      this.$store.subscribe((mutation) => {
        if (mutation.type === 'setDuration' || mutation.type === 'setRange') {
          if (this.timerId != undefined) {
            clearTimeout(this.timerId)
          }
          let registerHistory = () => {
            let newHistory = {
              duration: undefined,
              min: undefined,
              max: undefined
            }
            if (mutation.type === 'setDuration') {
              newHistory.duration = mutation.payload
            } else if (mutation.type === 'setRange') {
              newHistory.min = mutation.payload.min
              newHistory.max = mutation.payload.max
            }
            if (this.history.i == undefined ||
              this.history.h[this.history.i].duration !== newHistory.duration ||
              this.history.h[this.history.i].min !== newHistory.min ||
              this.history.h[this.history.i].max !== newHistory.max
            ) {
              if (this.history.i == undefined) {
                this.history.i = 0
              } else {
                this.history.i++
              }
              this.history.max = this.history.i
              this.history.h[this.history.i] = newHistory
            }
          }
          this.timerId = setTimeout(registerHistory, 1000)
        }
      })
    }
  }
</script>

<style>
.chart-control {
  margin: 1em;
  text-align: right;
}
</style>
