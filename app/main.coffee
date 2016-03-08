'use strict'

m = require 'mithril'
{bindActionCreators} = require 'redux'

{bindComponent, connectComponent} = require './mithril-redux'

NewTodoInput = require './components/new-todo-input'
TodoItem = require './components/todo-item'

configureStore = require './state/store'
{actions, Todo} = require './state/todos'


## Constants

# TODO: figure out storage
# STORE_KEY = 'todos-mithril'

FILTERS = [
  { name: 'all'      , href: '/'         , label: 'All'       }
  { name: 'active'   , href: '/active'   , label: 'Active'    }
  { name: 'completed', href: '/completed', label: 'Completed' }
]


## Initialization

init = ->
  rootElement = document.getElementById 'todoapp'

  store = configureStore()
  app = bindComponent App, {store}

  m.route.mode = 'hash'
  m.route rootElement, '/',
    '/': app
    '/:filter': app


## Mithril Components

App = connectComponent
  controller: ({dispatch}) ->
    filter = m.route.param 'filter'
    unless filter in ['active', 'completed']
      m.route '/' if filter
      filter = 'all'

    ctlr = bindActionCreators actions, dispatch
    ctlr.filter = filter
    ctlr

  view: (ctlr, {todos}) ->
    state =
      filter: ctlr.filter
      all: todos: todos
      active: todos: todos.filter Todo.isActive
      completed: todos: todos.filter Todo.isCompleted

    [
      header title: 'todos',
        m NewTodoInput, onNew: ctlr.createTodo

      if state.all.todos.length > 0
        [
          m Main,
            state: state
            onToggle: ctlr.toggleTodo
            onRename: ctlr.renameTodo
            onDestroy: ctlr.destroyTodo
            onToggleAll: ctlr.toggleAllTodos

          m Footer,
            filter: state.filter
            activeCount: state.active.todos.length
            completedCount: state.completed.todos.length
            onClearCompleted: ctlr.destroyCompletedTodos
        ]
    ]

  (state) ->
    todos: state.todos


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
  view: (ctlr, {filter, activeCount, completedCount, onClearCompleted}) ->
    m 'footer.footer', [
      m 'span.todo-count', [
        m 'strong', activeCount
        if activeCount is 1 then ' item left' else ' items left'
      ]

      m 'ul.filters',
        for f in FILTERS
          m 'li', [
            m 'a',
              class: if f.name is filter then 'selected'
              href: f.href
              config: m.route
              f.label
          ]

      if completedCount > 0
        m 'button.clear-completed', onclick: onClearCompleted, 'Clear completed'
    ]


## Launch

init()
