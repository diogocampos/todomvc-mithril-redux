'use strict'

{applyMiddleware, compose, createStore} = require '../redux'
thunk = require('redux-thunk').default

root = require './root'
{attachStorage} = require './storage'


exports.configureStore = ->
  defaultState = root.reducer undefined, {}

  createStore root.reducer, defaultState, compose(
    attachStorage
      key: 'todos-mithril-redux'
      fromStorage: (todos) -> root.configureState {todos}
      toStorage: root.selectors.getTodos

    applyMiddleware thunk
  )
