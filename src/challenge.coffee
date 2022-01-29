import React, {
  useState
  useEffect
} from 'react'

import {
  usePath
  useParams
  useLocation
  useNavigate
} from 'react-router-dom'

import InvoiceQR from './components/invoiceqr.coffee'

_ = require 'lodash'
axios = require 'axios'

import {
  Button
  Badge
  Card
  CardHeader
  CardTitle
  CardBody
  CardText
  CardFooter
  InputGroup
  Input
  Row
  Col
  ListGroup
  ListGroupItem
  Spinner
} from 'reactstrap'

Challenge = (props) -> (
  [loaded,set_loaded] = useState(false)
  [working,set_working] = useState(true)
  [invoice,set_invoice] = useState({})
  [challenge,set_challenge] = useState({})

  [params,location,navigate] = [
    useParams()
    useLocation()
    useNavigate()
  ]

  useEffect((->
    document.title = 'Challenge ' + params.id

    await update_challenge()
    await update_invoice()

  ),[])

  update_challenge = (->
    r = await axios({
      method: 'get'
      url: '/v1/challenge/' + params.id
    })

    set_challenge r.data
    set_loaded true

    return r.data
  )

  update_invoice = ((amount=10) ->
    set_invoice {}

    r = await axios({
      method: 'post'
      url: '/v1/invoice'
      data: {
        challenge: params.id
        amount: amount
      }
    })

    log /invoice_r.data/, r.data.data
    set_invoice r.data

    return r.data
  )

  start_open_game = (->
    window.open 'http://www.google.com'
  )

  cancel_challenge = (->
    await update_challenge()
  )

  if !loaded then return (
    <Col className="text-center mt-3">
      <Spinner/>
    </Col>
  )

  return (
    <Row className="mt-2 justify-content-center">

      <Col xs={12} md={10} lg={6}>
        <div className="text-center">
          Challenge <Badge color="success">{challenge._id}</Badge> ({challenge.mins}+{challenge.incr}) is open.
        </div>
      </Col>

      <div style={{clear:'both'}}/>

      <Col xs={12} md={10} lg={6} className="mt-4">
        <ListGroup className="text-center">

          <ListGroupItem className="justify-content-between">
            Total sats in pool:{' '}
            <Badge color="success">0</Badge>
          </ListGroupItem>

          <ListGroupItem className="justify-content-between">
            {
              if invoice?.data?.request?
                <div>
                  <InvoiceQR
                    value={invoice.data.request}
                    style={{
                      width: 400
                      maxWidth: '100%'
                    }}
                    onClick={->alert(invoice.data.request)}
                  />
                </div>
              else
                <Spinner/>
            }
            <div className="mt-1">
              <small className="text-muted">
                Tap or scan to deposit sats for this game.
                <br/>
                Cancel at any time before starting to be refunded.
              </small>
            </div>

          </ListGroupItem>
        </ListGroup>
      </Col>

      <div style={{clear:'both'}}/>

      <Col xs={12} md={10} lg={6} className="mt-4">
        <div className="text-center">
          <Button
            size="lg"
            color="success"
            disabled={true}
            onClick={-> await start_open_game()}
          >
            Start game on Lichess
          </Button>
        </div>
        <div className="text-center mt-3">
          <Button
            size="md"
            outline
            color="secondary"
            onClick={-> await cancel_challenge()}
          >
            Cancel challenge
          </Button>
          <Button
            size="md"
            outline
            color="secondary"
            onClick={-> await update_invoice()}
          >
            Update invoice
          </Button>
        </div>
      </Col>
    </Row>
  )
)

export default Challenge

