import 'babel-polyfill'

global.log = (x...) -> try console.log x...
global.Promise = global.P = require 'bluebird'

import React from 'react'
import ReactDOM from 'react-dom'

import {
  BrowserRouter,
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
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home/>}/>
        <Route path="/:id" element={<Challenge/>}/>
      </Routes>
    </BrowserRouter>
    <Footer/>
  </Container>

,document.getElementById('_'))

