'use strict'

m = require 'mithril'

TodoStore = require './todo-store'
{mx, boundMethods, table} = require './utils'


## Constants

KeyCode =
  ENTER: 13
  ESCAPE: 27

STORE_KEY = 'todos-mithril'

FILTERS = table [
  ['name'     , 'href'      , 'label'    ]
  ['all'      , '/'         , 'All'      ]
  ['active'   , '/active'   , 'Active'   ]
  ['completed', '/completed', 'Completed']
]


## Initialization

init = ->
  rootElement = document.getElementById 'todoapp'

  store = boundMethods new TodoStore STORE_KEY
  app = mx.boundComponent App, {store}

  m.route.mode = 'hash'
  m.route rootElement, '/',
    '/': app
    '/:filter': app


## Mithril Components

App =
  controller: ->
    filter = m.route.param 'filter'
    unless filter in ['active', 'completed']
      m.route '/' if filter
      filter = 'all'

    {filter}

  view: (ctlr, {store}) ->
    state =
      filter: ctlr.filter
      all: todos: store.all()
      active: todos: store.all 'active'
      completed: todos: store.all 'completed'

    [
      m Header,
        m NewTodo, onNew: store.addTodo

      if state.all.todos.length > 0
        [
          m Main,
            state: state
            onToggleAll: store.toggleAllTodos
            onToggle: store.toggleTodo
            onEdit: store.renameTodo
            onDestroy: store.removeTodo

          m Footer,
            state: state
            onClearCompleted: store.removeCompletedTodos
        ]
    ]


Header =
  view: (ctlr, children) ->
    m 'header.header', [
      m 'h1', 'todos'
      children
    ]


NewTodo =
  controller: ({onNew}) ->
    title = m.prop ''

    title: title
    handleKeydown: (event) ->
      if event.keyCode is KeyCode.ENTER
        if newTitle = title().trim()
          onNew title: newTitle
          title ''

  view: (ctlr) ->
    mx 'input.new-todo',
      placeholder: 'What needs to be done?'
      autofocus: true
      binds: ['oninput', 'value', ctlr.title]
      onkeydown: ctlr.handleKeydown


Main =
  view: (ctlr, {state, onToggleAll, onToggle, onEdit, onDestroy}) ->
    m 'section.main', [
      m 'input#toggle-all.toggle-all',
        type: 'checkbox'
        checked: state.active.todos.length is 0 and state.all.todos.length > 0
        onchange: onToggleAll

      m 'label', for: 'toggle-all', 'Mark all as complete'

      m 'ul.todo-list',
        for todo in state[state.filter].todos
          m Item, {todo, onToggle, onEdit, onDestroy}
    ]


Item =
  controller: ({todo, onToggle, onEdit, onDestroy}) ->
    title = m.prop todo.title
    editing = m.prop false

    commitChanges = ->
      editing false
      if newTitle = title().trim()
        onEdit id: todo.id, title: newTitle unless newTitle is todo.title
      else
        onDestroy id: todo.id

    discardChanges = ->
      title todo.title
      editing false

    title: title
    editing: editing

    handleToggle: -> onToggle id: todo.id
    handleDestroy: -> onDestroy id: todo.id

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


Footer =
  view: (ctlr, {state, onClearCompleted}) ->
    activeCount = state.active.todos.length
    completedCount = state.completed.todos.length

    m 'footer.footer', [
      m 'span.todo-count', [
        m 'strong', activeCount
        if activeCount is 1 then ' item left' else ' items left'
      ]

      m 'ul.filters',
        for filter in FILTERS
          m 'li', [
            m 'a',
              class: if state.filter is filter.name then 'selected'
              href: filter.href
              config: m.route
              filter.label
          ]

      if completedCount > 0
        m 'button.clear-completed', onclick: onClearCompleted, 'Clear completed'
    ]


## Launch

init()
