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

Invoice = require './../models/invoice'

lightning.listen = (->
  sub = client.subscribeToInvoices {lnd}
  sub.on 'invoice_updated', (data) ->

    # invoice was paid
    if data.id and data.is_confirmed and data.received
      await Invoice
        .findOne _id: data.id
        .exec defer e,invoice
      if e then throw e
      if invoice
        invoice.paid = true
        invoice.sats = data.received
        invoice.data = data
        await invoice.save defer e
        if e then throw e
)

lightning.listen()

lightning.create_invoice = (opt,cb) ->
  opt.lnd = lnd

  description = opt.memo ? opt.description ? process.env.NAME + _.uuid()
  opt.description = description

  sats = opt.sats ? opt.amount ? opt.tokens
  opt.tokens = +sats if sats

  opt.is_fallback_included = true
  opt.expires_at = new Date((_.time() + _.secs('7 days'))*1000).toISOString()

  return client.createInvoice opt, cb

lightning.get_invoice = (id,cb) ->
  opt = {lnd,id}
  return client.getInvoice opt, defer e,r

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





