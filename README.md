# covid-vue-chart
[![Netlify Status](https://api.netlify.com/api/v1/badges/3ada0c46-6f37-4736-a2ec-17d00b749ece/deploy-status)](https://app.netlify.com/sites/zunda-covid-vue-chart/deploys)

Vue application to plot time series from COVID-19 cases. Navigate to https://covid-chart.zunda.ninja/ for a sample deploy.

## Project setup
```
yarn install
```

### Fetches and formats data to be plotted
Fetches, parses, and formats data to be plotted.

```
yarn fetchdata
```

### Compiles and hot-reloads for development
```
yarn serve
```

### Compiles and minifies for production
The command also triggers `yarn fetchdata` to refresh the data.

```
yarn build
```

### Lints and fixes files
```
yarn lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

## License
### The app code
Copyright 2020 by zunda, under [MIT License](LICENSE).

### Favicon
https://fontawesome.com/icons/clinic-medical

Copyright by Fonticons, Inc., under [CC BY 4.0 License](https://fontawesome.com/license/free).

### Dependent packages
See [LICENSES](LICENSES) file.
