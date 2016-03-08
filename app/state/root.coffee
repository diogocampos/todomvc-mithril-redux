'use strict'

{combineReducers} = require 'redux'

filter = require './filter'
todos = require './todos'


## Reducer

exports.reducer = combineReducers
  filter: filter.reducer
  todos: todos.reducer
