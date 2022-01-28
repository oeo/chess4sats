import 'babel-polyfill'

global.log = (x...) -> try console.log x...
global.Promise = global.P = require 'bluebird'

import React from 'react'
import ReactDOM from 'react-dom'

import {
  BrowserRouter as Router,
  Route
} from 'react-router-dom'

import 'bootstrap/dist/css/bootstrap.min.css'
import "./../static/main.css"

import Home from './home.coffee'

ReactDOM.render(
  <Router>
    <div>
      <Route exact path="/" component={Home}/>
    </div>
  </Router>
,document.getElementById('_'))

