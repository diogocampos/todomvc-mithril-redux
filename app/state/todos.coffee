'use strict'

{actionCreator, assign, setItem, UUIDv4} = require './utils'


## Models

exports.Todo =
Todo = (title, completed) ->
  id: UUIDv4()
  title: title
  completed: completed ? false

Todo.isActive = (todo) ->
  not todo.completed

Todo.isCompleted = (todo) ->
  !!todo.completed


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


## Reducer

initialTodos = (Todo(args...) for args in [
  ['Taste JavaScript', true]
  ['Buy a unicorn', false]
])

exports.reducer = (todos = initialTodos, action) ->
  nextTodos = switch action.type

    when 'ADD_TODO'
      todos.concat [action.todo]

    when 'TOGGLE_TODO'
      [todo, index] = findTodoById todos, action.id
      if todo
        todo = assign todo, completed: not todo.completed
        setItem todos, index, todo

    when 'RENAME_TODO'
      [todo, index] = findTodoById todos, action.id
      if todo
        todo = assign todo, title: action.title
        setItem todos, index, todo

    when 'DESTROY_TODO'
      todos.filter (todo) -> todo.id isnt action.id

    when 'TOGGLE_ALL_TODOS'
      hasActiveTodos = todos.filter(Todo.isActive).length > 0
      todos.map (todo) -> assign todo, completed: hasActiveTodos

    when 'DESTROY_COMPLETED_TODOS'
      todos.filter Todo.isActive

  nextTodos or todos


findTodoById = (todos, id) ->
  for todo, index in todos
    return [todo, index] if todo.id is id
  [null, -1]
