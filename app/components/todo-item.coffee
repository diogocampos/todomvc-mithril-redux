'use strict'

m = require 'mithril'

{createComponent, KeyCode, mx} = require './utils'


## TodoItem

module.exports =
createComponent class TodoItem

  constructor: (@attrs) ->
    @title = m.prop ''
    @editing = m.prop false

  handleToggle: -> @attrs.onToggle @attrs.todo.id
  handleDestroy: -> @attrs.onDestroy @attrs.todo.id

  handleDblclick: ->
    @title @attrs.todo.title
    @editing true

  handleBlur: -> @commitChanges()

  handleKeydown: (event) ->
    switch event.keyCode
      when KeyCode.ENTER then @commitChanges()
      when KeyCode.ESCAPE then @discardChanges()

  commitChanges: ->
    @editing false
    if newTitle = @title().trim()
      unless newTitle is @attrs.todo.title
        @attrs.onRename @attrs.todo.id, newTitle
    else
      @attrs.onDestroy @attrs.todo.id

  discardChanges: ->
    @title @attrs.todo.title
    @editing false


  render: ->
    classes = ''
    classes += '.editing' if @editing()
    classes += '.completed' if @attrs.todo.completed

    m "li#{classes}", key: @attrs.todo.id, [
      if not @editing()
        m 'div.view', [
          m 'input.toggle',
            type: 'checkbox'
            checked: @attrs.todo.completed
            onchange: @handleToggle
          m 'label', ondblclick: @handleDblclick, @attrs.todo.title
          m 'button.destroy', onclick: @handleDestroy
        ]
      else
        mx 'input.edit',
          config: select
          binds: ['oninput', 'value', @title]
          onblur: @handleBlur
          onkeydown: @handleKeydown
    ]


## Helpers

select = (element, isInitialized, context) ->
  element.select() unless isInitialized
