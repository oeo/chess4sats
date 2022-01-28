_ = require('wegweg')({
  globals: on
})

conf = require './conf'
routes = require './routes'

express = require 'express'
mongoose = require 'mongoose'

mongoose.connect conf.mongo, (e) ->
  if e then throw e

module.exports.configure = configure = ((app,server=false) ->
  app.disable 'x-powered-by'
  app.use(require('body-parser').json())
  app.use(require('body-parser').urlencoded({extended:false}))

  app.use '/api', routes

  if server
    app.use '/', express.static(__dirname + '/../build')
    app.get '/', (req,res,next) ->
      res.sendFile(__dirname + '/../build/index.html')

  app.use (e,req,res,next) ->
    e = new Error(e) if _.type(e) isnt 'error'
    return res.status(500).json({
      error: e.toString().split(':').pop().trim()
    })

  if server
    app.use (req,res,next) -> res.redirect '/'

  return app
)

module.exports.app = app = do ->
  _app = configure(express(),false)
  return _app

if !module.parent
  _app = configure(express(),true)
  app.listen conf.http_port
  log ":#{conf.http_port}"

