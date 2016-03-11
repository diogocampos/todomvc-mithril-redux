'use strict'

m = require 'mithril'

{KeyCode, mx} = require './utils'


module.exports =
TodoInput =

  controller: ({onSubmit}) ->
    title = m.prop ''

    title: title
    handleKeydown: (event) ->
      if event.keyCode is KeyCode.ENTER
        if newTitle = title().trim()
          onSubmit newTitle
          title ''


  view: (ctlr) ->
    mx 'input.new-todo',
      placeholder: 'What needs to be done?'
      autofocus: true
      binds: ['oninput', 'value', ctlr.title]
      onkeydown: ctlr.handleKeydown
