_ = require('wegweg')({
  globals: on
})

lightning = require './../lib/lightning'

mongoose = require 'mongoose'

Invoice = new (Schema = mongoose.Schema) {

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


