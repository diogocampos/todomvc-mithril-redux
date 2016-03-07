'use strict'

m = require 'mithril'

{KeyCode, mx} = require '../utils'


module.exports =
NewTodoInput =

  controller: ({onNew}) ->
    title = m.prop ''

    title: title
    handleKeydown: (event) ->
      if event.keyCode is KeyCode.ENTER
        if newTitle = title().trim()
          onNew newTitle
          title ''

  view: (ctlr) ->
    mx 'input.new-todo',
      placeholder: 'What needs to be done?'
      autofocus: true
      binds: ['oninput', 'value', ctlr.title]
      onkeydown: ctlr.handleKeydown
