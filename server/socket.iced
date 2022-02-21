_ = require('wegweg')({
  globals: on
})

lightning = require './lib/lightning'
lichess = require './lib/lichess'

Challenge = require './models/challenge'
Invoice = require './models/invoice'

# connection handler
handler = (socket) ->
  log /we have a connection (from handler)/

  socket.emit 'message', 'hey whats going on bro thanks for joining in'

##
module.exports = handler

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

