import React, {Component} from 'react'

##
Error = (props) ->
  if typeof props.message isnt 'string'
    props.message = JSON.stringify(props.message)

  document.title = 'Error: ' + props.message

  <div class="container">

    <div class="row justify-content-center mt-3">
      <div class="col-lg-7 receipt-card">
        <div class="card bg-danger fff no-border">
          <div class="card-block">
            <p class="text-bold">
              Error
            </p>
            <p class="mb-0 text-fixed">
              {props.message}
            </p>
          </div>
        </div>
        <div class="mt-3 text-right">
          <button class="btn btn-sm btn-secondary bump-shadow" onClick={-> location.reload(true)}>Reload</button>
        </div>
      </div>
    </div>

  </div>

export default Error

