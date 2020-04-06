import { Line, mixins } from 'vue-chartjs'

export default {
  extends: Line,
  mixins: [mixins.reactiveProp],
  props: {
    chartData: {
      type: Object,
      default: null
    },
    optinos: {
      type: Object,
      default: null
    },
  },
  mounted () {
    this.renderChart(this.chartData, this.options)
  }
}
