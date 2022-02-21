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

router.get '/lnauth', (req,res,next) ->
  log 'GET /v1/lnauth', req.real_ip, req.query

  return res.json {
    status: "ERROR"
    reason: "blocked"
  }

router.get '/ping', (req,res,next) ->
  return res.json {
    pong: _.uuid()
    userhash: req.userhash
  }

router.post '/challenge', (req,res,next) ->
  await Challenge.create {
    p1_userhash: req.body.userhash ? undefined
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

# create invoice
router.post '/invoice', (req,res,next) ->
  challenge = false

  if req.body.challenge
    await Challenge
      .findOne {_id:req.body.challenge}, defer e,challenge
    if e then return next e
    if !challenge then return next new Error 'challenge_noexists'

  desc = process.env.NAME

  if challenge
    desc += ' challenge ' + challenge._id

  await Invoice.create {
    userhash: req.body.userhash ? undefined
    sats: req.body.sats ? req.body.amount ? undefined
    challenge: challenge?._id ? undefined
    description: desc
  }, defer e,invoice
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

