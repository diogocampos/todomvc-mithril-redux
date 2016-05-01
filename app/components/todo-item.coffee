'use strict'

m = require 'mithril'

{createComponent, KeyCode, mx} = require './utils'


## TodoItem

module.exports =
createComponent class TodoItem

  constructor: ({@todo, @onToggle, @onRename, @onDestroy}) ->
    @title = m.prop ''
    @editing = m.prop false


  handleToggle: => @onToggle @todo.id
  handleDestroy: => @onDestroy @todo.id

  handleDblclick: =>
    @title @todo.title
    @editing true

  handleKeydown: (event) =>
    switch event.keyCode
      when KeyCode.ENTER then @commitChanges()
      when KeyCode.ESCAPE then @discardChanges()

  handleBlur: => @commitChanges()


  commitChanges: ->
    @editing false
    if newTitle = @title().trim()
      unless newTitle is @todo.title
        @onRename @todo.id, newTitle
    else
      @onDestroy @todo.id

  discardChanges: ->
    @title @todo.title
    @editing false


  render: ({@todo, @onToggle, @onRename, @onDestroy}) ->
    classes = ''
    classes += '.editing' if @editing()
    classes += '.completed' if @todo.completed

    m "li#{classes}", key: @todo.id, [
      if not @editing()
        m 'div.view', [
          m 'input.toggle',
            type: 'checkbox'
            checked: @todo.completed
            onchange: @handleToggle
          m 'label', ondblclick: @handleDblclick, @todo.title
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
