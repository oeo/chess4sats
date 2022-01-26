_ = require('wegweg')({
  globals: on
})

conf = require './../conf'

module.exports = lichess = li = {}

lichess.create_challenge = ((opt={},cb) ->
  opt.rated ?= false
  opt['clock.limit'] ?= _.secs('15 minutes')
  opt['clock.increment'] ?= 0
  opt.variant = 'standard'
  opt.name ?= conf.name + '/' + _.uuid()

  await _.post "https://lichess.org/api/challenge/open", opt, defer e,r,b
  if e then return cb e

  if !b?.challenge?
    return cb new Error 'error creating challenge', b

  return cb null, b.challenge
)

if !module.parent
  await li.create_challenge {}, defer e,challenge
  log /e/, e
  log /challenge/, challenge

  exit 0



