_ = require('wegweg')({
  globals: on
  shelljs: on
})

lnurl = require 'lnurl'
crypto = require 'crypto'
qs = require 'querystring'

module.exports = lib = {}

lib.generate_lnurl = ((cb) ->

)

lib.generate_k1 = ((cb) ->
  str = crypto.randomBytes(32).toString('hex')
  return str
)

if !module.parent
  log _.fns(lnurl)
  log _.keys(lnurl)

  AUTH_K1 = lib.generate_k1()
  AUTH_URL = 'https://ec85-68-235-43-92.ngrok.io/v1/lnauth'

  url = AUTH_URL + '?' + qs.stringify({
    tag: 'login'
    k1: AUTH_K1
  })

  log url
  log lnurl.encode(url)
  #
  #log 'lnurl1dp68gurn8ghj7um5v93kketj9ehx2amn9ashq6f0d3hxzat5dqlhgct884kx7emfdcnxkvfa8qerxd3cxajrgvmpvejxzdnzvgmnyv3hvesn2c3hv9nxzve38yexzve38yunydf5vs6rzepnve3rqvnxxvckzde38p3rvetrxgmk2eg6eh22s'
  #log lnurl.encode('https://stacker.news/api/lnauth?tag=login&k1=823687d43afda6bb7227fa5b7afa3192a3199254d41d3fb02f31a718b6ec27ee')

  process.exit 0

