import {hot} from 'react-hot-loader'
import React, {Component} from 'react'
import {Redirect} from 'react-router-dom'
import autobind from 'react-autobind'
import Error from './error.coffee'

$ = require 'jquery'
_ = require 'lodash'
moment = require 'moment'

##
class Subscription extends Component

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
    document.title = 'Manage Your Subscription'

    @state.query = require('querystring').parse(
      @props.location.search?.substr?(1) ? ''
    )

    if !@state.query.id
      return @setState({error:'`query.id` is required'})

    @refresh()
  )

  handle_change: ((e) ->
    @state.form[e.target.name] = e.target.value
    @forceUpdate()
  )

  handle_submit: ((e) ->
    e.preventDefault()
    @update()
  )

  refresh: (->
    return false if @state.error

    r = await $.get '/q?id=' + @state.query.id

    try @state[k] = v for k,v of r
    @state.loaded = true
    @forceUpdate()

    @setState({
      form: {
        product: r.product._id
        time: r.subscription.billing_interval_human
        next: (do =>
          next_date = new Date(@state.subscription.next_bill.time * 1000)
          next_date = new Date() if new Date() > next_date
          d = moment(next_date)
          return d.format 'YYYY-MM-DD'
        )
      }
    })

    window.scrollTo(0,0)
  )

  cancel: (->
    packet = _.clone(@state.form)
    packet.id = @state.query.id
    packet.cancel = true

    r = await $.post '/s', packet

    @setState({error:r.error})
    @refresh()
  )

  update: (->
    if @state.subscription.status isnt 'ACTIVE'
      packet = _.clone(@state.form)
      packet.id = @state.query.id
      packet.renew = true
      r = await $.post '/s', packet
      @setState({error:r.error})

    packet = _.clone(@state.form)
    packet.id = @state.query.id
    packet.update = true
    packet.next_mdy = (do =>
      next_mdy = moment(packet.next,'YYYY-MM-DD')
      return next_mdy.format 'MM/DD/YYYY'
    )

    r = await $.post '/s', packet

    @setState({error:r.error})
    @refresh()
  )

  render: (->
    if @state.error then return <Error message={@state.error}/>
    if !@state.loaded then return <div/>

    [customer,subscription,product,products] = [
      @state.customer
      @state.subscription
      @state.product
      @state.products
    ]

    bg_class = 'bg-blue-gradient'
    bg_class = 'bg-danger' if subscription.status isnt 'ACTIVE'

    <div class="container">

      {### summary ###}
      <div class="row justify-content-center mt-3">
        <div class="col-lg-7 receipt-card">
          <div class="card #{bg_class} text-fixed fff text-upper">
            <div class="card-block more-padding">
              <div>
                <img src="static/logo-alt-white.svg" style={{width:300,maxWidth:'100%'}}/>
              </div>
              <div style={{height:15}}/>
              <div>
                {customer.name}<br/>
                {_.compact([
                  customer.shipping_address_1
                  customer.shipping_address_2
                ]).join(' ')}
                <br/>
                {customer.shipping_city}, {customer.shipping_state} {customer.shipping_zipcode}
              </div>
              <div style={{height:15}}/>
              <div>
                <div class="line-xs">
                  <div class="row">
                    <div class="col-sm-9">
                      {product.name}
                    </div>
                    <div class="col-sm-3 text-right">
                      ${subscription.price.toFixed 2}
                    </div>
                  </div>
                </div>
                <div class="text-right">
                  {
                    if subscription.status is 'ACTIVE'
                      <span>Shipped every {subscription.billing_interval_human}</span>
                    else
                      <span>{subscription.status}</span>
                  }
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>

      {### controls ###}
      <div class="row justify-content-center controls-row">
        <div class="col-lg-7">
          <div class="card bt-0">

            <div class="card-block">
              <form onSubmit={@handle_submit}>
                <div class="row">
                  <div class="col-md-7">
                    <div class="form-group">
                      <label class="text-bold">Product</label>
                      {for item in products
                        <div class="form-check" style={{marginLeft:20}} key={"product_" + item._id}>
                          <input
                            class="form-check-input"
                            type="radio"
                            id={"product_" + item._id}
                            name="product"
                            value={item._id}
                            checked={@state.form.product is item._id}
                            onChange={@handle_change}
                          />
                          <label class="form-check-label" for={"product_" + item._id}>
                            {item.name} <span class="text-bold green">${item.price.toFixed 2}</span>
                          </label>
                        </div>
                      }
                    </div>
                  </div>
                  <div class="col-md-5">
                    <div class="form-group">
                      <label class="text-bold">Frequency</label>
                      {for item in [
                        '30 days'
                        '60 days'
                        '90 days'
                        '120 days'
                      ]
                        <div class="form-check" style={{marginLeft:20}} key={"time_" + item}>
                          <input
                            class="form-check-input"
                            type="radio"
                            id={"time_" + item}
                            name="time"
                            value={item}
                            checked={@state.form.time is item}
                            onChange={@handle_change}
                          />
                          <label class="form-check-label" for={"time_" + item}>
                            {item}
                          </label>
                        </div>
                      }
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="form-group col-md-7 mt-3">
                    <label class="text-bold">Next billing date:</label>
                    <input
                      class="form-control"
                      type="date"
                      name="next"
                      max={
                        d = moment(new Date)
                        d.add(1,'year')
                        d.format 'YYYY-MM-DD'
                      }
                      min={
                        d = moment(new Date)
                        d.format 'YYYY-MM-DD'
                      }
                      value={@state.form.next ? false}
                      onChange={@handle_change}
                    />
                  </div>
                </div>
                <div class="form-group text-left mt-2 mb-2">
                  <button onClick={@submit} class="btn btn-md btn-primary bump-shadow">Save Preferences</button>
                </div>
              </form>
            </div>

          </div>
          {
            if subscription.status is 'ACTIVE'
              <div class="mt-2 text-right">
                <a onClick={@cancel.bind(@)} class="cancel-link pointer">
                  Cancel this plan
                </a>
              </div>
          }
        </div>
      </div>

      <div style={{height:15}}/>
    </div>
  )

##
export default hot(module)(Subscription)

