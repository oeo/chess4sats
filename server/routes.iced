_ = require('wegweg')({
  globals: on
})

conf = require './conf'
express = require 'express'

router = module.exports = new express.Router

router.get '/create', (req,res,next) ->
  _.get (api_url = conf.API_SERVER + '/public/subscription-info/' + req.query.id), (e,r) ->
    if e then return next e
    if r.body?.error then return next new Error r.body.error
    return res.json(r.body?.response ? {})

