require('dotenv').config({
  path: __dirname + '/../../.env'
})

_ = require('wegweg')({
  globals: on
})

client = require 'lightning'

lnd = client.authenticatedLndGrpc(lnd_opt = {
  cert: process.env.LND_CERT
  macaroon: process.env.LND_MACAROON
  socket: process.env.LND_SOCKET
}).lnd

lightning = module.exports = {}

lightning.create_invoice = (opt,cb) ->
  opt.lnd = lnd
  opt.description ?= 'new-invoice'
  opt.is_fallback_included = true
  opt.expires_at = new Date((_.time() + _.secs('48 hours'))*1000).toISOString()

  await client.createInvoice opt, defer e,r
  if e then return cb e

  return cb null, r

if !module.parent
  ###
  await client.getWalletInfo {
    lnd: lnd
  }, defer e,r

  log e
  log r
  ###

  await lightning.create_invoice {}, defer e,r
  log e
  log r

  exit 0





