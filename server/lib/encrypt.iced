crypto = require 'crypto'

module.exports = lib = {}

ENCRYPTION_SALT = "cfc2210ec7108ed3f5e512f74e018b7f"

lib.encrypt = lib.enc = (text,key) ->
  if !key then key = ENCRYPTION_SALT

  cipher = crypto.createCipher('aes-256-cbc',key)
  crypted = cipher.update(text,'utf8','hex')
  crypted += cipher.final('hex')

  return crypted

lib.decrypt = lib.dec = (text,key) ->
  if !key then key = ENCRYPTION_SALT

  decipher = crypto.createDecipher('aes-256-cbc',key)
  dec = decipher.update(text,'hex','utf8')
  dec += decipher.final('utf8')

  return dec

module.exports = lib

if !module.parent
  ENCRYPTION_SALT = "12345"

  tmp = {}
  tmp.orig = "hello, world. this is a funny thing."
  tmp.encrypted = lib.enc(tmp.orig,ENCRYPTION_SALT)
  tmp.decrypted = lib.dec(tmp.encrypted,ENCRYPTION_SALT)

  console.log tmp
  process.exit 0

