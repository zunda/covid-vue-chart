<template>
  <div class="chart-control">
    <input
      v-model="duration"
      placeholder="days" type="number" size="4" min="1"
      title="Number of recent days to be shown"
    />
    <button
      :disabled="history.i == undefined || history.i == 0"
      v-on:click="goPrev()"
      title="Show previous date range">
      <font-awesome-icon icon="undo" />
    </button>
    <button :disabled="history.i == undefined || history.i == history.max"
      v-on:click="goNext()"
      title="Show next date range">
      <font-awesome-icon icon="redo" />
    </button>
    <button v-on:click="resetZoom" title="Show entire data">
      <font-awesome-icon icon="clinic-medical" />
    </button>
    <select v-model="cumulative" title="Select cumulative or daily new cases">
      <option value="true" title="Show cumulative cases">Cumulative</option>
      <option value="false" title="Show daily new cases">New</option>
    </select>
  </div>
</template>

<script>
  import Vue from 'vue'
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faUndo, faRedo, faClinicMedical } from '@fortawesome/free-solid-svg-icons'
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
  library.add(faUndo)
  library.add(faRedo)
  library.add(faClinicMedical)
  Vue.component('font-awesome-icon', FontAwesomeIcon)

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
          const x = this.$store.state.duration
          if (x != undefined && !isNaN(x)) {
            return -x / (24*3600*1000)
          } else {
            return ''
          }
        },
        set(duration) {
          const x = parseFloat(duration)
          if (!isNaN(x)) {
            this.$store.commit('setDuration',  -x * 24*3600*1000)
          } else {
            this.$store.commit('setDuration',  undefined)
          }
        }
      },
      cumulative: {
        get() {
          return this.$store.state.cumulative ? "true" : "false"
        },
        set(cumulative) {
            this.$store.commit('setCumulative', cumulative === "true")
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
        const i = this.history.i
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
          const registerHistory = () => {
            const newHistory = {
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
  margin-left: 1em;
  margin-right: 1em;
  text-align: right;
}

input {
  width:  4em;
  height: 1em;
  margin: 0;
}

input::-webkit-outer-spin-button, input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
input[type=number] {
    -moz-appearance:textfield;
}
</style>
