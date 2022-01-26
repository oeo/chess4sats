_ = require('wegweg')({
  globals: on
})

PRODUCTION = process.env.NODE_ENV is 'production'

path = require 'path'
webpack = require 'webpack'

CopyWebpackPlugin = require 'copy-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

HtmlWebpackPluginConfig = new HtmlWebpackPlugin({
  template: './src/index.html'
  filename: 'index.html'
  hash: true
})

css_dev = [
  'style-loader'
  'css-loader'
]

css_prod = ExtractTextPlugin.extract({
  fallback: 'style-loader'
  use: [
    'css-loader'
  ]
  publicPath: '/build'
})

module.exports = {
  entry: [
    './src/index.coffee'
  ]

  output: {
    filename: '_.js'
    publicPath: '/'
    path: path.resolve(__dirname, 'build')
  }

  devServer: {
    hot: true
    open: true
    compress: false
    quiet: false
    port: require(__dirname + '/server/conf').HTTP_PORT
    overlay: {
      errors: true
    }
    contentBase: path.join(__dirname, 'build')
    historyApiFallback: true
    before: ((app) ->
      app = require(__dirname + '/server')(app,false)
      app.use('/static',require('express').static('./static'))
      return app
    )
  }

  module: {
    rules: [
      {
        test: /\.coffee$/
        use: [
          {
            loader: 'babel-loader'
            options: {
              presets: ['env','react']
            }
          }
          'coffee-loader'
        ]
        exclude: /node_modules/
      }
      {
        test: /\.css$/
        use: (if PRODUCTION then css_prod else css_dev)
      }
    ]
  }

  plugins: [
    HtmlWebpackPluginConfig
    new CopyWebpackPlugin([{from:'./static',to:'static'}])
    new webpack.HotModuleReplacementPlugin()
    new webpack.NamedModulesPlugin()
  ]
}

