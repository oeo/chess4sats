_ = require('wegweg')({
  globals: on
})

axios = require 'axios'
pgn = require 'pgn-parser'

conf = require './../conf'

redis = _.redis(conf.redis)
_key = (x) -> conf.redis_prefix + ':' + x

module.exports = lichess = li = {}

lichess.create_open_challenge = ((opt={},cb) ->
  if opt.mins then opt['clock.limit'] = _.secs(opt.mins + ' minutes')
  if opt.incr then opt['clock.increment'] = +opt.incr

  opt.rated ?= false
  opt['clock.limit'] ?= _.secs('15 minutes')
  opt['clock.increment'] ?= 0
  opt.variant = 'standard'

  opt.name ?= conf.name + ':' + new Date().getTime()

  api_url = "https://lichess.org/api/challenge/open"

  axios({
    method: 'post'
    url: api_url
    data: opt
  }).then((r) =>
    if !r?.data?.challenge?
      return cb new Error 'error creating challenge', r
    return cb null, r.data.challenge
  ).catch((e) =>
    return cb e
  )
)

lichess.get_game = (game_id,cb) ->
  api_url = "http://lichess.org/game/export/#{game_id}"

  axios({
    method: 'get'
    url: api_url
  }).then((r) =>
    if !r?.data?
      return cb new Error 'error fetching game', game_id, r
    return cb null, pgn.parse(r.data)
  ).catch (e) => return cb e

if !module.parent
  await li.create_open_challenge {}, defer e,challenge
  log /e/, e
  log /challenge/, challenge

  ###
  await li.get_game 'Sx4bQmid', defer e,game
  log /e/, e
  log /game/, game
  ###

  exit 0

lichess._encrypt = (str) ->


