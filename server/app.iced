require('dotenv').config({
  path: __dirname + '/../.env'
})

_ = require('wegweg')({
  globals:on
})

events = require './events'
events.emit 'ping'

express = require 'express'
mongoose = require 'mongoose'

mongoose.connect process.env.MONGO_URI, (e) ->
  if e then throw e

module.exports.configure = configure = ((app,server=false) ->
  app.disable 'x-powered-by'
  app.use(require('body-parser').json())
  app.use(require('body-parser').urlencoded({extended:false}))

  app.use (req,res,next) ->
    console.log('request:',req.path,req.query)

    if (tmp = req.headers['x-forwarded-for'])
      req.real_ip = tmp.split(',').shift().trim()
    else
      req.real_ip = req.ip

    req.user_hash = _.md5([
      req.real_ip
      req.headers['user-agent']
    ].join(''))

    res.set 'x-userhash', req.user_hash

    next()

  if server
    app.use '/', express.static(__dirname + '/../build')
    app.get '/', (req,res,next) ->
      log '/index get..'
      res.sendFile(__dirname + '/../build/index.html')

  app.use '/v1', (require './routes')

  app.use (e,req,res,next) ->
    e = new Error(e) if _.type(e) isnt 'error'
    return res.status(500).json({
      error: e.toString().split(':').pop().trim()
    })

  if server
    app.use (req,res,next) -> res.redirect '/'

  return app
)

module.exports.app = do ->
  _app = configure(express(),false)
  return _app

if !module.parent
  app = configure(express(),true)
  app.listen port = process.env.HTTP_PORT
  log ":#{port}"

