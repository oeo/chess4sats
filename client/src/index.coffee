import 'babel-polyfill'

global.log = (x...) -> try console.log x...
global.Promise = global.P = require 'bluebird'

global.store = require 'store2'

import React from 'react'
import ReactDOM from 'react-dom'

import {
  BrowserRouter,
  HashRouter,
  Routes
  Route
} from 'react-router-dom'

import 'bootstrap/dist/css/bootstrap.min.css'
import "./../static/main.css"

import {
  Container
  Row
  Col
  Spinner
} from 'reactstrap'

import {
  io
} from 'socket.io-client'

userhash = require './lib/userhash.coffee'
await userhash.get()

global.socket = io({
  path: '/socket/' + userhash.get_cache()
  query: {
    userhash: (do -> userhash.get_cache())
  }
})

socket.onAny (event,data=null) ->
  log /socket_event/, event, data

import Header from './components/header.coffee'
import Footer from './components/footer.coffee'

import Home from './home.coffee'
import Challenge from './challenge.coffee'

ReactDOM.render(

  <Container>
    <Header/>
    <HashRouter>
      <Routes>
        <Route path="/:id" element={<Challenge/>}/>
        <Route path="/" element={<Home/>}/>
      </Routes>
    </HashRouter>
    <Footer/>
  </Container>

,document.getElementById('_'))

