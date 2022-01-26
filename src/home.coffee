import {hot} from 'react-hot-loader'
import React, {Component} from 'react'
import {Redirect} from 'react-router-dom'
import autobind from 'react-autobind'
import Error from './error.coffee'

_ = require 'lodash'
moment = require 'moment'

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

  render: (->
    if @state.error then return <Error message={@state.error}/>
    if !@state.loaded then return <div/>

    <div className="container">

      {### summary ###}
      <div className="row justify-content-center">
        <div className="col-sm-8 mt-4">
          <div className="text-center">
            <img src="/static/logo-black-no-background.svg" style={{width:200,maxWidth:'100%'}}/>
          </div>
        </div>
      </div>

      <div style={{height:15}}/>
    </div>
  )

##
export default hot(module)(Home)

