import 'babel-polyfill'

global.log = (x...) -> try console.log x...
global.Promise = global.P = require 'bluebird'

import {
  io
} from 'socket.io-client'

global.socket = io({path:'/socket/'})

socket.on 'message', (data) ->
  log 'got a message', data

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

