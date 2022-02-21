_ = require('wegweg')({
  globals: on
})

lightning = require './lib/lightning'
lichess = require './lib/lichess'
events = require './lib/events'

Challenge = require './models/challenge'
Invoice = require './models/invoice'

events.on 'challenge_updated', (data) ->
  log /a challenge has been updated/, data

events.on 'challenge_created', (data) ->
  log /a challenge has been created/, data

# connection handler
module.exports = handler = ((socket) ->
  log /new websocket connection/, socket.conn.id

  socket.emit 'message', 'hey whats going on bro thanks for joining in'
)

module.exports = handler


