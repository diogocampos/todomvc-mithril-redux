'use strict'

require 'todomvc-common'
m = require 'mithril'


## Initialization

init = ->
  rootElement = document.getElementById 'todoapp'
  m.mount rootElement, App


## Mithril Components

App =
  view: (ctlr) ->
    ''


## Launch

init()
