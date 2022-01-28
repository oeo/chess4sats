import {hot} from 'react-hot-loader'
import React, {Component} from 'react'
import {Redirect} from 'react-router-dom'
import autobind from 'react-autobind'

import Error from './components/error.coffee'
import Header from './components/header.coffee'
import Footer from './components/footer.coffee'

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
} from 'reactstrap'

##
class Challenge extends Component

  state: {
    loaded: false
    error: false
    query: {}
    form: {}
  }

  constructor: (props) ->
    super(props)

  componentWillMount: ->
    autobind(@)

  componentDidMount: (->
    r = await axios({
      method: 'get'
      url: '/v1/challenge/' + @props.match.params.id
    })

    @state.challenge = r.data

    console.log /challenge/, @state.challenge

    @state.query = require('querystring').parse(
      @props.location.search?.substr?(1) ? ''
    )

    document.title = 'New Challenge ' + @state.challenge.note + ' - chess2sats'

    @state.loaded = true
    @forceUpdate()
  )

  update_challenge: (->
    r = await axios({
      method: 'get'
      url: '/v1/challenge/' + @props.match.params.id
    })

    @state.challenge = r.data
    @forceUpdate()
  )

  render: (->
    if @state.error then return <Error message={@state.error}/>
    if @state.redirect then return <Redirect to={@state.redirect}/>
    if !@state.loaded then return <div/>

    <div className="container">
      <Header/>

      <div className="row justify-content-center">
        <div className="col-lg-6 col-md-10 col-sm-12">
          <div className="text-center">
            <p>
              Challenge <Badge color="success">{@state.challenge._id}</Badge> ({@state.challenge.mins}+{@state.challenge.incr}) is open.
            </p>
          </div>
        </div>
      </div>

      <Row className="mt-2 justify-content-center">
        <Col xs={12} md={10} lg={6}>
          <ListGroup className="text-center">
            <ListGroupItem className="justify-content-between">
              Total sats reward for a winning{' '}
              <Badge color="success">0</Badge>
            </ListGroupItem>
            <ListGroupItem className="justify-content-between">
              Opponent sats deposit{' '}
              <Badge color="dark">0</Badge>
            </ListGroupItem>
            <ListGroupItem className="justify-content-between">
              <div>
                Your deposit{' '}
                <Badge color="dark">0</Badge>
              </div>
              <div className="mt-2">
                <img
                  src={"/v1/qr-image/" + @state.challenge.p1_invoice.request + "?buffer=1"}
                  style={{
                    width: 350
                    maxWidth: '90%'
                  }}
                />
              </div>
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
      </Row>
      <div className="row justify-content-center mt-3">
        <div className="text-center col-lg-6 col-md-10 col-xs-12">
          <div className="text-center">
            <Button
              size="lg"
              color="success"
              onClick={@open_game}
            >
              Start game in new tab
            </Button>
          </div>
          <div className="text-center mt-3">
            <Button
              size="md"
              color="secondary"
              outline
              onClick={@cancel_challenge}
            >
              Cancel and refund
            </Button>
          </div>
        </div>
      </div>


      <Footer/>
    </div>
  )

##
export default hot(module)(Challenge)

