'use strict'

{applyMiddleware, combineReducers, createStore} = require 'redux'
thunk = require('redux-thunk').default

todos = require './todos'


rootReducer = combineReducers
  todos: todos.reducer

module.exports =
configureStore = (initialState) ->
  createStore rootReducer, initialState,
    applyMiddleware(
      thunk
    )
