import 'babel-polyfill'

global.log = (x...) -> try console.log x...
global.Promise = global.P = require 'bluebird'

import React from 'react'
import ReactDOM from 'react-dom'

import {
  BrowserRouter as Router,
  Route
} from 'react-router-dom'

import Home from './home.coffee'

import 'bootstrap/dist/css/bootstrap.min.css';

ReactDOM.render(
  <Router>
    <div>
      <Route exact path="/" component={Home}/>
    </div>
  </Router>
,document.getElementById('_'))

