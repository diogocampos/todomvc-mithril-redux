'use strict'

{applyMiddleware, createStore} = require 'redux'
thunk = require('redux-thunk').default

root = require './root'




module.exports = (initialState) ->
  createStore root.reducer, initialState,
    applyMiddleware(
      thunk
    )
