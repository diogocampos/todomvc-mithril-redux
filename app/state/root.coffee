'use strict'

{combineReducers} = require 'redux'

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

# TODO use reselect: https://github.com/reactjs/reselect

exports.selectors = s =

  getFilter: (state) ->
    state.filter


  getTodos: (state) ->
    state.todos


  getActiveTodos: (state) ->
    todos = s.getTodos state
    todos.filter Todo.isActive


  getCompletedTodos: (state) ->
    todos = s.getTodos state
    todos.filter Todo.isCompleted


  getVisibleTodos: (state) ->
    filter = s.getFilter state

    switch filter
      when 'all' then s.getTodos state
      when 'active' then s.getActiveTodos state
      when 'completed' then s.getCompletedTodos state


  areAllTodosCompleted: (state) ->
    todos = s.getTodos state
    activeTodos = s.getActiveTodos state

    todos.length > 0 and activeTodos.length is 0
