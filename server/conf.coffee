config = {
  name: 'chess4sats'
  http_port: 10061
  redis: 'localhost'
  redis_prefix: 'chess4sats'
}

## merge and export
if require('fs').existsSync(CONFIG_FILE_LOCAL = __dirname + '/conf.local.coffee')
  flatten = require 'flat'
  unflatten = require('flat').unflatten
  flat_extra = flatten require(CONFIG_FILE_LOCAL)
  flat_conf = flatten config
  flat_conf[k] = v for k,v of flat_extra
  config = unflatten flat_conf

module.exports = config

