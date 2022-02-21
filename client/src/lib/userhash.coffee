axios = require 'axios'

module.exports = userhash = {}

userhash._key = '__userhash'

userhash.get = ((force=false) ->
  if !force
    str = store(@_key)
    if str then return str

  r = await axios({
    method: 'get'
    url: '/v1/ping'
  })

  if str = r?.data?.userhash
    store(@_key,str)
  else
    str = 'unknown-' + Math.random().toString().split('.').pop()

  return str
)

userhash.get_cache = -> store(@_key)
userhash.set = (val) -> store(@_key,val)

