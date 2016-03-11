'use strict'

{applyMiddleware, createStore} = require '../redux'
thunk = require('redux-thunk').default

root = require './root'
storage = require './storage'


## Constants

STORAGE_KEY = 'todos-mithril-redux'


## configureStore

module.exports = (initialState) ->
  initialState = root.configureState
    todos: JSON.parse localStorage.getItem(STORAGE_KEY) or 'null'

  middlewares = [
    storage.middleware
      key: STORAGE_KEY
      selector: root.selectors.getTodos

    thunk
  ]

  createStore root.reducer, initialState, applyMiddleware(middlewares...)
