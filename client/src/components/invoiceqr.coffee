import React, {
  useState
  useEffect
} from 'react'

import * as kjua from 'kjua'

import {
  Button
  Input
  InputGroup
  InputGroupText
} from 'reactstrap'

InvoiceQR = ((props) ->
  k_opts = {
    render: 'image'
    size: 300
    crisp: true
    minVersion: 1
    rounded: 100
    ecLevel: 'M'
    text: props.value
    disabled: false
    quiet: 0
  }

  k_img = kjua(k_opts)

  k_props = (do =>
    tmp = {}
    for x in k_img.attributes
      continue if x.name in ['value','crossorigin','style','width','height']
      tmp[x.name] = x.value
    return tmp
  )

  for k,v of props
    k_props[k] = v

  if k_props.disabled
    k_props.style.opacity = 0.25

  ele = React.createElement('img',k_props,null)
  
  return ele
)

export default InvoiceQR

