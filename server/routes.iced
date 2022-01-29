_ = require('wegweg')({
  globals: on
})

lightning = require './lib/lightning'
lichess = require './lib/lichess'

Challenge = require './models/challenge'
Invoice = require './models/invoice'

qrcode = require 'qrcode'
express = require 'express'

router = module.exports = new express.Router

router.get '/', (req,res,next) ->
  return res.json {
    pong: _.uuid()
    user_hash: req.user_hash
  }

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
    mins: +req.body.mins ? 15
    incr: +req.body.incr ? 0
    note: req.body.note ? undefined
  }, defer e,doc
  if e then return next e

  return res.json doc.toJSON()

router.get '/challenge/:_id', (req,res,next) ->
  await Challenge
    .findOne {_id:req.params._id}, defer e,doc
  if e then return next e
  if !doc then return res.sendStatus(404)

  return res.json doc.toJSON()

router.get '/invoice/:_id', (req,res,next) ->
  await Invoice
    .findOne {_id:req.params._id}, defer e,doc
  if e then return next e
  if !doc then return res.sendStatus(404)

  return res.json doc.toJSON()

router.post '/invoice', (req,res,next) ->
  challenge = false

  if req.body.challenge
    await Challenge
      .findOne {_id:req.body.challenge}, defer e,challenge
    if e then return next e
    if !challenge then return next new Error 'challenge_noexists'

  await Invoice.create {
    sats: req.body.sats ? req.body.amount ? undefined
    challenge: challenge?._id ? undefined
    description: JSON.stringify({
      note: challenge?.note ? undefined
      challenge: challenge?._id ? undefined
      user_hash: req.user_hash
    })
  }, defer e,invoice
  if e then return next e

  if challenge
    await challenge.add_invoice invoice._id, defer e
    if e then return next e

  return res.json invoice.toJSON()

###
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
###

