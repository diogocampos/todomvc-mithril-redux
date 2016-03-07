'use strict'

m = require 'mithril'

TodoStore = require './todo-store'
{mx, boundMethods, table} = require './utils'

NewTodoInput = require './components/new-todo-input'
TodoItem = require './components/todo-item'


## Constants

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
      header title: 'todos',
        m NewTodoInput, onNew: (title) -> store.addTodo {title}

      if state.all.todos.length > 0
        [
          m Main,
            state: state
            onToggle: (id) -> store.toggleTodo {id}
            onRename: (id, title) -> store.renameTodo {id, title}
            onDestroy: (id) -> store.removeTodo {id}
            onToggleAll: store.toggleAllTodos

          m Footer,
            state: state
            onClearCompleted: store.removeCompletedTodos
        ]
    ]


header = ({title}, children) ->
  m 'header.header', [
    m 'h1', title
    children
  ]


Main =
  view: (ctlr, {state, onToggleAll, onToggle, onRename, onDestroy}) ->
    m 'section.main', [
      m 'input#toggle-all.toggle-all',
        type: 'checkbox'
        checked: state.active.todos.length is 0 and state.all.todos.length > 0
        onchange: onToggleAll

      m 'label', for: 'toggle-all', 'Mark all as complete'

      m 'ul.todo-list',
        for todo in state[state.filter].todos
          m TodoItem, {todo, onToggle, onRename, onDestroy}
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
