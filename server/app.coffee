_ = require('wegweg')({
  globals: on
})

express = require 'express'

conf = require './conf'
routes = require './routes'

configure = ((app,server=false) ->
  app.disable 'x-powered-by'
  app.use(require('body-parser').json())
  app.use(require('body-parser').urlencoded({extended:false}))

  if server
    app.use '/', express.static(__dirname + '/../build')
    app.get '/', (req,res,next) ->
      res.sendFile(__dirname + '/../build/index.html')

  app.use '/', routes

  app.use (e,req,res,next) ->
    e = new Error(e) if _.type(e) isnt 'error'
    return res.status(500).json({
      error: e.toString().split(':').pop().trim()
    })

  if server
    app.use (req,res,next) -> res.redirect '/'

  return app
)

app = express()
app = configure(app,true)

app.listen conf.http_port
log ":#{conf.http_port}"

