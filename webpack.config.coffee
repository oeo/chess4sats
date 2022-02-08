require('dotenv').config()

_ = require('wegweg')({
  globals: on
})

PRODUCTION = process.env.NODE_ENV is 'production'

path = require 'path'
webpack = require 'webpack'

CopyWebpackPlugin = require 'copy-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
MiniCssExtractPlugin = require("mini-css-extract-plugin")

HtmlWebpackPluginConfig = new HtmlWebpackPlugin({
  template: './src/index.html'
  filename: 'index.html'
  hash: true
})

module.exports = {
  entry: [
    './src/index.coffee'
  ]

  output: {
    filename: '_.js'
    publicPath: '/'
    path: path.resolve(__dirname,'build')
  }

  devServer: {
    hot: false
    open: false
    compress: false
    port: process.env.HTTP_PORT
    allowedHosts: 'auto'
    client: {
      overlay: on
    }
    static: {directory: path.join(__dirname,'build')}
    historyApiFallback: true
    onBeforeSetupMiddleware: ((ds) ->
      ds.app = require(__dirname + '/server/app').configure(ds.app,false)
      ds.app.use('/static',require('express').static(__dirname + '/static'))
    )
  }

  resolve: {
    fallback:
      querystring: false
  }
  module: {
    rules: [
      {
        test: /\.coffee$/
        use: [
          {
            loader: 'babel-loader'
            options: {
              presets: ['@babel/preset-env','@babel/react']
            }
          }
          'coffee-loader'
        ]
        exclude: /node_modules/
      }
      {
        test: /\.css$/
        use: [MiniCssExtractPlugin.loader, "css-loader"]
      }
    ]
  }

  plugins: [
    new MiniCssExtractPlugin()
    HtmlWebpackPluginConfig
    new CopyWebpackPlugin([{from:'./static',to:'static'}])
    new webpack.HotModuleReplacementPlugin()
  ]
}

