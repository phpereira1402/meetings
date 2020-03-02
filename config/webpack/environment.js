const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')


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



environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
