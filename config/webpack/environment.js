const { environment } = require('@rails/webpacker')


const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: ['jquery/src/jquery'],
    jQuery: 'jquery/src/jquery',
    //Chart: 'chart.js/dist/Chart',
    //SimpleBar: 'simplebar/dist/simplebar',
    // trying to load jquery-scroll-lock plugin
    // scrollLock: 'jquery-scroll-lock/dist/jquery-scrollLock', <- this doesn't seem to work
  })
)

module.exports = environment
