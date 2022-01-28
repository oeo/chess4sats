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
} from 'reactstrap'

##
class Home extends Component

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
    document.title = 'Play Chess for Bitcoin - chess4sats'

    @state.query = require('querystring').parse(
      @props.location.search?.substr?(1) ? ''
    )

    @setState loaded:true
  )

  create_challenge: (->
    r = await axios({
      method: 'post'
      url: '/v1/challenge'
      data: {
        mins: 10
        incr: 5
      }
    })

    @setState {redirect:'/' + r.data._id}
  )

  render: (->
    if @state.error then return <Error message={@state.error}/>
    if @state.redirect then return <Redirect to={@state.redirect}/>
    if !@state.loaded then return <div/>

    <div className="container">
      <Header/>

      <div className="row justify-content-center">
        <div className="col-lg-5 col-md-10 col-sm-12">
          <div className="text-center">
            <p>
              Challenge your friends to a high-stakes
              game of <a href="https://www.lichess.org" target="_blank">Lichess</a> by
              wagering sats over the Lightning Network.
            </p>
          </div>
          <div className="mt-3 text-center">
            <Button
              size="lg"
              color="success"
              onClick={@create_challenge}
            >
              Create a challenge
            </Button>
          </div>
        </div>
      </div>

      <Footer/>
    </div>
  )

##
export default hot(module)(Home)

