_ = require('wegweg')({
  globals:on
})

lightning = require 'lightning'

module.exports = eve = _.events()

eve.on 'ping', ->
  log {pong:_.uuid()}

