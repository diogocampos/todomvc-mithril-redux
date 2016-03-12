'use strict'

m = require 'mithril'

{createComponent, KeyCode, mx} = require './utils'


module.exports =
createComponent class TodoInput

  constructor: (@attrs) ->
    @title = m.prop ''

  handleKeydown: (event) ->
    if event.keyCode is KeyCode.ENTER
      if newTitle = @title().trim()
        @attrs.onSubmit newTitle
        @title ''


  render: ->
    mx 'input.new-todo',
      placeholder: 'What needs to be done?'
      autofocus: true
      binds: ['oninput', 'value', @title]
      onkeydown: @handleKeydown
