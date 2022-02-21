require('dotenv').config({
  path: __dirname + '/../.env'
})

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
    hot: true
    open: false
    compress: false
    port: process.env.HTTP_PORT_WEBPACK
    allowedHosts: 'auto'
    client: {overlay:on}
    static: {directory: path.join(__dirname,'build')}
    historyApiFallback: true

    proxy: {
      "/v1/*": {
        target: "http://0.0.0.0:" + process.env.HTTP_PORT_SERVER
        changeOrigin: true
      }
      '/socket/*': {
        target: 'http://0.0.0.0:' + process.env.HTTP_PORT_SERVER
        ws: true
        changeOrigin: true
      }
    }

  }

  resolve: {
    fallback:
      querystring: false
      url: false
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

  experiments: {
    topLevelAwait: true
  }
}

