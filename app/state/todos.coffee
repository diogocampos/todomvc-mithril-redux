'use strict'

{createAction, setItem, setProperties, UUIDv4} = require './utils'


## Models

exports.Todo =
Todo = (title, completed) ->
  id: UUIDv4()
  title: title
  completed: completed ? false

Todo.isActive = (todo) ->
  not todo.completed

Todo.isCompleted = (todo) ->
  todo.completed


## Action Creators

_addTodo    = createAction 'ADD_TODO', 'todo'
toggleTodo  = createAction 'TOGGLE_TODO', 'id'
renameTodo  = createAction 'RENAME_TODO', 'id', 'title'
destroyTodo = createAction 'DESTROY_TODO', 'id'

toggleAllTodos        = createAction 'TOGGLE_ALL_TODOS'
destroyCompletedTodos = createAction 'DESTROY_COMPLETED_TODOS'


createTodo = (title, completed) ->
  (dispatch) ->
    dispatch _addTodo Todo title, completed


exports.todosActions = {
  createTodo, toggleTodo, renameTodo, destroyTodo
  toggleAllTodos, destroyCompletedTodos
}


## Reducer

initialTodos = (Todo(args...) for args in [
  ['Taste JavaScript', true]
  ['Buy a unicorn', false]
])

exports.todosReducer = (todos = initialTodos, action) ->
  nextTodos = switch action.type

    when 'ADD_TODO'
      todos.concat [action.todo]

    when 'TOGGLE_TODO'
      [todo, index] = findTodoById todos, action.id
      if todo
        todo = setProperties todo, completed: not todo.completed
        setItem todos, index, todo

    when 'RENAME_TODO'
      [todo, index] = findTodoById todos, action.id
      if todo
        todo = setProperties todo, title: action.title
        setItem todos, index, todo

    when 'DESTROY_TODO'
      todos.filter (todo) -> todo.id isnt action.id

    when 'TOGGLE_ALL_TODOS'
      hasActiveTodos = todos.filter(Todo.isActive).length > 0
      todos.map (todo) -> setProperties todo, completed: hasActiveTodos

    when 'DESTROY_COMPLETED_TODOS'
      todos.filter Todo.isActive

  nextTodos or todos


findTodoById = (todos, id) ->
  for todo, index in todos
    return [todo, index] if todo.id is id
  [null, -1]
