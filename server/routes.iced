_ = require('wegweg')({
  globals: on
})

lightning = require './lib/lightning'
lichess = require './lib/lichess'
Challenge = require './models/challenge'

qrcode = require 'qrcode'
express = require 'express'

router = module.exports = new express.Router

router.get '/ping', (req,res,next) ->
  return res.json pong:_.uuid()

router.get '/qr-image/:data', (req,res,next) ->
  if !(data = req.params.data)
    return next new Error 'data required'

  await qrcode.toDataURL data, {width:800,margin:0}, defer e,data_url
  if e then return next e

  # return json
  if !req.query.buffer then return res.json({data_url})

  # return buffer
  buffer = new Buffer(data_url.split(',').pop(),'base64')

  res.set 'content-type', 'image/png'
  res.end(buffer)

router.post '/challenge', (req,res,next) ->
  await Challenge.create {
    mins: +req.body.mins ? 10
    incr: +req.body.incr ? 0
    note: req.body.note ? undefined
  }, defer e,doc
  if e then return next e

  return res.json doc

router.get '/challenge/:_id', (req,res,next) ->
  await Challenge.findOne _id:req.params._id, defer e,doc
  if e then return next e
  return res.json doc.toJSON()

# @tmp
router.get '/challenge/:_id/deposit', (req,res,next) ->
  await Challenge.findOne _id:req.params_id, defer e,doc
  if e then return next e

  required = [
    'player'
    'amount'
  ]

  await challenge.deposit req.query.player, req.query.amount, defer e,doc
  if e then return next e

  return res.json doc

module.exports = router

