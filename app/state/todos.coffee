'use strict'

{UUIDv4} = require './utils'


Todo = (title, completed) ->
  id: UUIDv4()
  title: title
  completed: completed ? false
