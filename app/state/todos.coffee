'use strict'

{actionCreator, UUIDv4} = require './utils'


## Models

Todo = (title, completed) ->
  id: UUIDv4()
  title: title
  completed: completed ? false


## Action Creators

addTodo     = actionCreator 'ADD_TODO', 'todo'
toggleTodo  = actionCreator 'TOGGLE_TODO', 'id'
renameTodo  = actionCreator 'RENAME_TODO', 'id', 'title'
destroyTodo = actionCreator 'DESTROY_TODO', 'id'

toggleAllTodos        = actionCreator 'TOGGLE_ALL_TODOS'
destroyCompletedTodos = actionCreator 'DESTROY_COMPLETED_TODOS'


createTodo = (title, completed) ->
  (dispatch) ->
    dispatch addTodo Todo title, completed


exports.actions = {
  createTodo, toggleTodo, renameTodo, destroyTodo
  toggleAllTodos, destroyCompletedTodos
}
