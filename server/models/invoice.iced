_ = require('wegweg')({
  globals: on
})

lightning = require './../lib/lightning'
events = require './../lib/events'

mongoose = require 'mongoose'

Invoice = new (Schema = mongoose.Schema) {
  userhash: String
  account: {type:String,ref:'Account'}

  challenge: {
    type: String
    ref: 'Challenge'
  }

  description: String

  sats: {type: Number,default:0}
  paid: {type:Boolean,default:false}

  data: Schema.Types.Mixed

}, {collection:'invoices',strict:off}

Invoice.plugin((schema) ->
  schema.options.usePushEach = true
  schema.add {_id:String,mtime:Number,ctime:Number}
  schema.pre 'save', (next) ->
    @mtime = (t = _.time())
    @ctime ?= t
    @_id ?= _.uuid()
    next()
)

Invoice.pre 'save', (next) ->
  if @isNew
    await lightning.create_invoice {
      description: @description ? undefined
      tokens: @sats ? undefined
    }, defer e, invoice_data
    if e then return next e

    @_id = invoice_data.id
    @data = invoice_data

  else

    # invoice is paid so update the challenge
    if @paid
      events.emit 'invoice_paid', {
        _id: @_id
        sats: @sats
      }

      Challenge = require './challenge'

      await Challenge
        .findOne _id:@challenge
        .exec defer e,challenge
      if e then throw e

      if challenge
        await challenge.add_invoice @_id, defer e
        if e then throw e

  return next()

Invoice.methods.refresh = (next) ->
  await lightning.get_invoice @_id, defer e,invoice_data
  if e then return next e

  @data = invoice_data
  @markModified('data')

  return @save next

##
_m = mongoose.model 'Invoice', Invoice
module.exports = _m


