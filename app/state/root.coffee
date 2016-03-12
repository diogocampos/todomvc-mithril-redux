'use strict'

{combineReducers} = require '../redux'

{filterReducer, filterSelectors} = require './filter'
{todosReducer, todosSelectors} = require './todos'


## Reducer

exports.reducer = combineReducers
  filter: filterReducer
  todos: todosReducer


## configureState

exports.configureState = ({todos}) ->
  filter: filterReducer undefined, {}
  todos: todosReducer todos, {}


## Selectors

exports.selectors = s = {}

s.getFilter = (state) ->
  filterSelectors.getFilter state.filter

s.getTodos = (state) ->
  todosSelectors.getTodos state.todos

s.getActiveTodos = (state) ->
  todos = s.getTodos state
  todosSelectors.getActiveTodos todos

s.getCompletedTodos = (state) ->
  todos = s.getTodos state
  todosSelectors.getCompletedTodos todos

s.getVisibleTodos = (state) ->
  switch s.getFilter state
    when 'all' then s.getTodos state
    when 'active' then s.getActiveTodos state
    when 'completed' then s.getCompletedTodos state

s.hasActiveTodos = (state) ->
  todos = s.getTodos state
  todosSelectors.hasActiveTodos todos
