'use strict'

m = require 'mithril'

{KeyCode, mx} = require '../utils'


module.exports =
TodoItem =


  controller: ({todo, onToggle, onRename, onDestroy}) ->
    title = m.prop todo.title
    editing = m.prop false

    commitChanges = ->
      editing false
      if newTitle = title().trim()
        onRename todo.id, newTitle unless newTitle is todo.title
      else
        onDestroy todo.id

    discardChanges = ->
      title todo.title
      editing false


    title: title
    editing: editing

    handleToggle: -> onToggle todo.id
    handleDestroy: -> onDestroy todo.id

    handleDblclick: -> editing true
    handleBlur: commitChanges

    handleKeydown: (event) ->
      switch event.keyCode
        when KeyCode.ENTER then commitChanges()
        when KeyCode.ESCAPE then discardChanges()


  view: (ctlr, {todo}) ->
    classes = ''
    classes += '.editing' if ctlr.editing()
    classes += '.completed' if todo.completed

    m "li#{classes}", key: todo.id, [
      if not ctlr.editing()
        m 'div.view', [
          m 'input.toggle',
            type: 'checkbox'
            checked: todo.completed
            onchange: ctlr.handleToggle
          m 'label', ondblclick: ctlr.handleDblclick, todo.title
          m 'button.destroy', onclick: ctlr.handleDestroy
        ]
      else
        mx 'input.edit',
          config: mx.select
          binds: ['oninput', 'value', ctlr.title]
          onblur: ctlr.handleBlur
          onkeydown: ctlr.handleKeydown
    ]
