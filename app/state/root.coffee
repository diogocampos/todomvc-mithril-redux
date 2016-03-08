'use strict'

{combineReducers} = require 'redux'

{filterReducer} = require './filter'
{todosReducer, Todo} = require './todos'


## Reducer

exports.reducer = combineReducers
  filter: filterReducer
  todos: todosReducer


## Selectors

# TODO use reselect: https://github.com/reactjs/reselect

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


exports.areAllTodosCompleted =
areAllTodosCompleted = (state) ->
  todos = getTodos state
  activeTodos = getActiveTodos state

  todos.length > 0 and activeTodos.length is 0
