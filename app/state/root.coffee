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
  filter: filterReducer null, {}
  todos: todosReducer todos, {}


## Selectors

exports.selectors = s = {}


s.getFilter = (state) ->
  state.filter


s.getTodos = (state) ->
  state.todos


s.getActiveTodos = createSelector [s.getTodos],
  _getActiveTodos = (todos) ->
    todos.filter Todo.isActive


s.getCompletedTodos = createSelector [s.getTodos],
  _getCompletedTodos = (todos) ->
    todos.filter Todo.isCompleted


s.getVisibleTodos = createSelector [s.getFilter, s.getTodos],
  (filter, todos) ->
    switch filter
      when 'all' then todos
      when 'active' then _getActiveTodos todos
      when 'completed' then _getCompletedTodos todos


s.areAllTodosCompleted = createSelector [s.getTodos, s.getActiveTodos],
  (todos, activeTodos) ->
    todos.length > 0 and activeTodos.length is 0
