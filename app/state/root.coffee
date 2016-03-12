'use strict'

{combineReducers} = require '../redux'
{createSelector} = require 'reselect'

{filterReducer} = require './filter'
{todosReducer, Todo} = require './todos'


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
  state.filter


s.getTodos = (state) ->
  state.todos


s.getActiveTodos = createSelector [s.getTodos],
  (todos) ->
    todos.filter Todo.isActive


s.getCompletedTodos = createSelector [s.getTodos],
  (todos) ->
    todos.filter Todo.isCompleted


s.getVisibleTodos = (state) ->
  switch s.getFilter state
    when 'all' then s.getTodos state
    when 'active' then s.getActiveTodos state
    when 'completed' then s.getCompletedTodos state


s.areAllTodosCompleted = createSelector [s.getTodos, s.getActiveTodos],
  (todos, activeTodos) ->
    todos.length > 0 and activeTodos.length is 0
