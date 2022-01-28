crypto = require 'crypto'

module.exports = lib = {}

lib.encrypt = lib.enc = (text,key) ->
  if !key then key = process.env.ENCRYPTION_KEY

  cipher = crypto.createCipher('aes-256-cbc',key)
  crypted = cipher.update(text,'utf8','hex')
  crypted += cipher.final('hex')

  return crypted

lib.decrypt = lib.dec = (text,key) ->
  if !key then key = process.env.ENCRYPTION_KEY

  decipher = crypto.createDecipher('aes-256-cbc',key)
  dec = decipher.update(text,'hex','utf8')
  dec += decipher.final('utf8')

  return dec

module.exports = lib

if !module.parent
  CUSTOM_KEY = "12345"

  tmp = {}
  tmp.orig = "hello, world. this is a funny thing."
  tmp.encrypted = lib.enc(tmp.orig,CUSTOM_KEY)
  tmp.decrypted = lib.dec(tmp.encrypted,CUSTOM_KEY)

  console.log tmp
  process.exit 0

