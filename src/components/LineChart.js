import { Line, mixins } from 'vue-chartjs'
import 'chartjs-plugin-colorschemes'
import 'chartjs-plugin-zoom'

export default {
  extends: Line,
  mixins: [mixins.reactiveProp],
  props: {
    chartData: {
      type: Object,
      default: null
    },
    options: {
      type: Object,
      default: null
    },
  },
  mounted: function () {
    this.renderChart(this.chartData, this.options)
  },
  watch: {
     options () {
        this.renderChart(this.chartData, this.options);
     }
   }
}
