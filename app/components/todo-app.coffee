'use strict'

m = require 'mithril'
{bindActionCreators} = require '../redux'

TodoInput = require './todo-input'
TodoItem = require './todo-item'
{createComponent} = require './utils'

s = require('../state/root').selectors
{filterActions} = require '../state/filter'
{todosActions} = require '../state/todos'


## Constants

FILTERS =
  'all':       path: '/'         , label: 'All'
  'active':    path: '/active'   , label: 'Active'
  'completed': path: '/completed', label: 'Completed'


## TodoApp

module.exports =
createComponent class TodoApp

  constructor: ({dispatch}) ->
    filter = m.route.param 'filter'
    unless filter in ['active', 'completed']
      m.route '/' if filter
      filter = 'all'

    dispatch filterActions.setFilter filter
    @actions = bindActionCreators todosActions, dispatch


  render: ({getState}) ->
    state = getState()
    todos = s.getTodos state

    m 'div', [
      header title: 'todos',
        m TodoInput, onSubmit: @actions.createTodo

      if todos.length > 0 then [
        todoList {state, @actions}
        footer {state, @actions}
      ]
    ]


## header

header = ({title}, children) ->
  m 'header.header', [
    m 'h1', title
    children
  ]


## todoList

todoList = ({state, actions}) ->
  hasActiveTodos = s.hasActiveTodos state
  visibleTodos = s.getVisibleTodos state

  m 'section.main', [
    m 'input#toggle-all.toggle-all',
      type: 'checkbox'
      checked: not hasActiveTodos
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


## footer

footer = ({state, actions}) ->
  currentFilter = s.getFilter state
  activeTodos = s.getActiveTodos state
  completedTodos = s.getCompletedTodos state

  m 'footer.footer', [
    m 'span.todo-count', [
      m 'strong', activeTodos.length
      if activeTodos.length is 1 then ' item left' else ' items left'
    ]

    m 'ul.filters',
      for filter, args of FILTERS
        m 'li', [
          m 'a',
            class: if filter is currentFilter then 'selected'
            href: args.path, config: m.route
            args.label
        ]

    if completedTodos.length > 0
      m 'button.clear-completed',
        onclick: actions.destroyCompletedTodos,
        'Clear completed'
  ]
