'use strict'

{table} = require './utils'


## Constants

DEFAULT_TODOS = table [
  ['title'           , 'completed']
  ['Taste JavaScript',  true      ]
  ['Buy a unicorn'   ,  false     ]
]


## TodoStore

module.exports =
class TodoStore

  constructor: (key) ->
    @_key = key
    @_load()

  _load: ->
    json = if @_key then localStorage.getItem @_key
    if json
      @_todos = JSON.parse json
    else
      @_todos = []
      DEFAULT_TODOS.forEach @addTodo.bind this

  _save: ->
    if @_key
      json = JSON.stringify @_todos
      try localStorage.setItem @_key, json
    @_cached = null

  all: (filter = 'all') ->
    unless @_cached
      @_cached = all: @_todos, active: [], completed: []
      for todo in @_todos
        @_cached[if todo.completed then 'completed' else 'active'].push todo
    @_cached[filter]

  findById: (id) ->
    for todo, index in @_todos
      return [todo, index] if todo.id is id
    [null, -1]

  addTodo: ({title, completed = false}) ->
    todo = {id: uniqueId(), title, completed}
    @_todos.push todo
    @_save()

  toggleAllTodos: ->
    if @_todos.length > 0
      hasActive = @all('active').length > 0
      todo.completed = hasActive for todo in @_todos
      @_save()

  toggleTodo: ({id}) ->
    [todo, index] = @findById id
    if todo?
      todo.completed = not todo.completed
      @_save()

  renameTodo: ({id, title}) ->
    [todo, index] = @findById id
    if todo?
      todo.title = title
      @_save()

  removeTodo: ({id}) ->
    [todo, index] = @findById id
    if todo?
      @_todos.splice index, 1
      @_save()

  removeCompletedTodos: ->
    @_todos = @all 'active'
    @_save()


## Helpers

uniqueId = ->
  "#{Date.now()}#{Math.random()}"
