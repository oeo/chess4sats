_ = require('wegweg')({
  globals: on
})

mongoose = require 'mongoose'

Account = new (Schema = mongoose.Schema) {

  pubkey: String

}, {collection:'accounts',strict:off}

Invoice.plugin((schema) ->
  schema.options.usePushEach = true
  schema.add {_id:String,mtime:Number,ctime:Number}
  schema.pre 'save', (next) ->
    @mtime = (t = _.time())
    @ctime ?= t
    @_id ?= _.uuid()
    next()
)

##
_m = mongoose.model 'Account', Account
module.exports = _m

