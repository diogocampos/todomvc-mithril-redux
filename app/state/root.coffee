'use strict'

{combineReducers} = require 'redux'

filter = require './filter'
todos = require './todos'


{Todo} = todos


## Reducer

exports.reducer = combineReducers
  filter: filter.reducer
  todos: todos.reducer


## Selectors

exports.getFilter =
getFilter = (state) ->
  state.filter


exports.getTodos =
getTodos = (state) ->
  state.todos


exports.getActiveTodos =
getActiveTodos = (state) ->
  todos = getTodos state
  todos.filter Todo.isActive


exports.getCompletedTodos =
getCompletedTodos = (state) ->
  todos = getTodos state
  todos.filter Todo.isCompleted


exports.getVisibleTodos =
getVisibleTodos = (state) ->
  filter = getFilter state

  switch filter
    when 'all' then getTodos state
    when 'active' then getActiveTodos state
    when 'completed' then getCompletedTodos state
