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
  Alert
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
  [invoice_disabled,set_invoice_disabled] = useState(false)
  [invoice,set_invoice] = useState({})
  [challenge,set_challenge] = useState({})
  [loaded,set_loaded] = useState(false)

  params = useParams()

  useEffect((->
    document.title = 'Challenge ' + params.id

    await update_challenge()
    await update_invoice()
  ),[])

  useEffect((->
    if challenge?._id and invoice?._id
      set_loaded true
  ),[challenge,invoice])

  update_challenge = (->
    r = await axios({
      method: 'get'
      url: '/v1/challenge/' + params.id
    })

    set_challenge r.data
  )

  update_invoice = ((amount=10) ->
    set_invoice_disabled true

    r = await axios({
      method: 'post'
      url: '/v1/invoice'
      data: {
        challenge: params.id
        amount: amount
      }
    })

    set_invoice r.data
    set_invoice_disabled false
  )

  start_open_game = (->
    window.open 'http://www.google.com'
  )

  if !loaded then return (
    <Col className="text-center mt-3">
      <Spinner/>
    </Col>
  )

  return (
    <Row className="justify-content-center">

      <Col xs={12} md={10} lg={5}>
        <ListGroup className="text-center">

          <ListGroupItem className="justify-content-between">
            <Badge pill color="success">Lichess game is ready</Badge>
            <br/>
            <Badge color="danger">Waiting on P1</Badge>
            <br/>
            <Badge color="danger">Waiting on P2</Badge>
          </ListGroupItem>

          <ListGroupItem className="justify-content-between">
            <div>
              Sats: {' '}
              0 (~$0.00 USD)
            </div>

            {
              if invoice?.data?.request?
                <div>
                  <InvoiceQR
                    value={invoice.data.request}
                    disabled={invoice_disabled}
                    style={{
                      width: 300
                      height: 300
                    }}
                  />
                </div>
            }
            <div className="mt-1">
              <small className="text-muted">
                Scan to deposit sats for this game.
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
            Start game
          </Button>
        </div>
        <div className="text-center mt-3">
          <Button
            size="sm"
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

