'use strict'

m = require 'mithril'

TodoApp = require './components/todo-app'
{configureStore} = require './state/store'


store = configureStore()

rootElement = document.getElementById 'todoapp'
app = m.component TodoApp, store

m.route.mode = 'hash'
m.route rootElement, '/',
  '/': app
  '/:filter': app
