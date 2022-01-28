_ = require('wegweg')({
  globals: on
})

lightning = require './../lib/lightning'
lichess = require './../lib/lichess'
encrypt = require './../lib/encrypt'

mongoose = require 'mongoose'
funny = require 'funny-versions'

Challenge = new (Schema = mongoose.Schema) {
  funny_name: String
  note: String

  mins: {type:Number,default:15}
  incr: {type:Number,default:0}

  p1_color: String
  p2_color: String

  p1_invoice: Schema.Types.Mixed
  p1_deposit: Number
  p1_deposit_time: Number

  p2_invoice: Schema.Types.Mixed
  p2_deposit: Number
  p2_deposit_time: Number

  lichess_id_encrypted: String
  lichess_challenge: Schema.Types.Mixed

  lichess_game: Schema.Types.Mixed
  lichess_game_mtime: Number

  reward: Number
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
  @note = process.env.NAME + ' game ' + @_id

  if @isNew
    await @create_open_challenge false, defer e
    if e then return next e

    await lightning.create_invoice {
      description: @note + ' deposit p1'
    }, defer e, p1_invoice
    if e then return next e

    await lightning.create_invoice {
      description: @note + ' deposit p2'
    }, defer e, p2_invoice
    if e then return next e

    @p1_invoice = _.omit p1_invoice, (bad = [
      'secret'
      'tokens'
      'mtokens'
      'created_at'
    ])

    @p2_invoice = _.omit p2_invoice, bad

  return next()

Challenge.methods.create_open_challenge = (save=true,next) ->
  if _.type(save) is 'function'
    next = save
    save = true

  await lichess.create_open_challenge {
    name: @note
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

Challenge.methods.deposit = (player_int,amount_sats,next) ->
  player_int = +player_int
  if player_int !in [1,2]
    return next new Error 'invalid player_int'

  this['p' + player_int + '_deposit'] += +amount_sats
  this['p' + player_int + '_deposit_time'] += _.time()

  return @save next

##
_m = mongoose.model 'Challenge', Challenge
module.exports = _m


