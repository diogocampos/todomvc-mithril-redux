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

  view: (actions, {getState}) ->
    state = getState()
    todos = s.getTodos state

    [
      header title: 'todos',
        m TodoInput, onSubmit: actions.createTodo

      if todos.length > 0
        [
          m TodoList, {state, actions}
          m Footer, {state, actions}
        ]
    ]


header = ({title}, children) ->
  m 'header.header', [
    m 'h1', title
    children
  ]


TodoList =
  view: (_, {state, actions}) ->
    allCompleted = s.areAllTodosCompleted state
    visibleTodos = s.getVisibleTodos state

    m 'section.main', [
      m 'input#toggle-all.toggle-all',
        type: 'checkbox'
        checked: allCompleted
        onchange: actions.toggleAllTodos

      m 'label', for: 'toggle-all', 'Mark all as complete'

      m 'ul.todo-list',
        for todo in visibleTodos
          m TodoItem,
            todo: todo
            onToggle: actions.toggleTodo
            onRename: actions.renameTodo
            onDestroy: actions.destroyTodo
    ]


Footer =
  view: (_, {state, actions}) ->
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
        m 'button.clear-completed',
          onclick: actions.destroyCompletedTodos,
          'Clear completed'
    ]


## Launch

init()
