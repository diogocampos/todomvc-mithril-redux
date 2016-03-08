'use strict'

m = require 'mithril'

TodoApp = require './components/todo-app'
{bindComponent} = require './components/utils'
configureStore = require './state/store'


store = configureStore()

rootElement = document.getElementById 'todoapp'
app = bindComponent TodoApp, store

m.route.mode = 'hash'
m.route rootElement, '/',
  '/': app
  '/:filter': app
