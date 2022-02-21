_ = require('wegweg')({
  globals: on
})

lightning = require './../lib/lightning'
lichess = require './../lib/lichess'
encrypt = require './../lib/encrypt'

eve = require './../lib/events'

mongoose = require 'mongoose'
funny = require 'funny-versions'

Challenge = new (Schema = mongoose.Schema) {
  p1_userhash: {type:String,required:true}
  p2_userhash: {type:String,default:null}

  p1_color: String
  p2_color: String

  p1_ready: Boolean
  p2_ready: Boolean

  funny_name: String
  note: String

  mins: {type:Number,default:15}
  incr: {type:Number,default:0}

  lichess_id_encrypted: String
  lichess_challenge: Schema.Types.Mixed

  lichess_game: Schema.Types.Mixed
  lichess_game_mtime: Number

  invoices: [
    {type:String,ref:'Invoice'}
  ]

  reward: {type:Number,default:0}
  reward_claimed: {type:Boolean,default:false}
  reward_claimed_time: Number

}, {collection:'challenges',strict:on}

Challenge.plugin((schema) ->
  schema.options.usePushEach = true
  schema.add {_id:String,mtime:Number,ctime:Number}
  schema.pre 'save', (next) ->
    @mtime = (t = _.time())
    @ctime ?= t
    @_id ?= _.uuid()
    next()
)

Challenge.pre 'save', (next) ->
  @p1_color = (colors = _.shuffle(['white','black'])).pop()
  @p2_color = colors.pop()

  @funny_name = funny.generate()

  if @isNew
    await @create_open_challenge false, defer e
    if e then return next e

  if @isNew
    eve.emit "challenge_created", @toJSON()
  else
    eve.emit "challenge_updated", @toJSON()

  return next()

Challenge.methods.create_open_challenge = (save=true,next) ->
  if _.type(save) is 'function'
    next = save
    save = true

  await lichess.create_open_challenge {
    name: process.env.NAME + ' challenge ' + @_id
    mins: @mins
    incr: @incr
  }, defer e,challenge_data
  if e then return next e

  @lichess_id_encrypted = encrypt.enc(challenge_data.id)
  @lichess_challenge = _.omit(challenge_data, [
    'id'
    'url'
    'urlWhite'
    'urlBlack'
  ])

  if save
    return @save next
  else
    return next()

Challenge.methods.add_invoice = (invoice_id,next) ->
  Invoice = require './invoice'

  await Invoice.findOne {
    _id: invoice_id
  }, defer e,exists
  if e then return next e
  if !exists then return next new Error 'invoice_noexists'

  @invoices ?= []

  if invoice_id !in @invoices
    @invoices.push invoice_id
    @reward += exists.sats
    @markModified('invoices')
    return @save next
  else
    return next()

Challenge.methods.deposit = (player_int,amount_sats,next) ->
  player_int = +player_int
  if player_int !in [1,2]
    return next new Error 'invalid player_int'

  this['p' + player_int + '_deposit'] += +amount_sats
  this['p' + player_int + '_deposit_time'] += _.time()

  return @save next

Challenge.methods.create_invoice = (opt,next) ->
  return next()

##
_m = mongoose.model 'Challenge', Challenge
module.exports = _m


