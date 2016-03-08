'use strict'

m = require 'mithril'
{bindActionCreators} = require 'redux'

TodoInput = require './components/todo-input'
TodoItem = require './components/todo-item'
{bindComponent} = require './components/utils'

configureStore = require './state/store'
s = require './state/root'
{filterActions} = require './state/filter'
{todosActions, Todo} = require './state/todos'


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
  app = bindComponent App, store

  m.route.mode = 'hash'
  m.route rootElement, '/',
    '/': app
    '/:filter': app


## Mithril Components

App =
  controller: ({dispatch}) ->
    filter = m.route.param 'filter'
    unless filter in ['active', 'completed']
      m.route '/' if filter
      filter = 'all'

    dispatch filterActions.setFilter filter
    bindActionCreators todosActions, dispatch

  view: (ctlr, store) ->
    state = store.getState()

    [
      header title: 'todos',
        m TodoInput, onSubmit: ctlr.createTodo

      if s.getTodos(state).length > 0
        [
          m TodoList, store,
            onToggle: ctlr.toggleTodo
            onRename: ctlr.renameTodo
            onDestroy: ctlr.destroyTodo
            onToggleAll: ctlr.toggleAllTodos

          m Footer, store,
            onClearCompleted: ctlr.destroyCompletedTodos
        ]
    ]


header = ({title}, children) ->
  m 'header.header', [
    m 'h1', title
    children
  ]


TodoList =
  view: (_, store, {onToggle, onRename, onDestroy, onToggleAll}) ->
    state = store.getState()

    todos = s.getTodos state
    activeTodos = s.getActiveTodos state
    visibleTodos = s.getVisibleTodos state

    allCompleted = todos.length > 0 and activeTodos.length is 0

    m 'section.main', [
      m 'input#toggle-all.toggle-all',
        type: 'checkbox'
        checked: allCompleted
        onchange: onToggleAll

      m 'label', for: 'toggle-all', 'Mark all as complete'

      m 'ul.todo-list',
        for todo in visibleTodos
          m TodoItem, {todo, onToggle, onRename, onDestroy}
    ]


Footer =
  view: (_, store, {onClearCompleted}) ->
    state = store.getState()

    currentFilter = s.getFilter state
    activeTodos = s.getActiveTodos state
    completedTodos = s.getCompletedTodos state

    m 'footer.footer', [
      m 'span.todo-count', [
        m 'strong', activeTodos.length
        if activeTodos.length is 1 then ' item left' else ' items left'
      ]

      m 'ul.filters',
        for args in FILTERS
          m 'li', [
            m 'a',
              class: if args.name is currentFilter then 'selected'
              href: args.href
              config: m.route
              args.label
          ]

      if completedTodos.length > 0
        m 'button.clear-completed', onclick: onClearCompleted, 'Clear completed'
    ]


## Launch

init()
