'use strict'

m = require 'mithril'


## KeyCode

exports.KeyCode =
KeyCode =
  ENTER: 13
  ESCAPE: 27


## mx

exports.mx =
mx = (selector, attrs, children) ->
  for key, transform of extensions
    if attrs[key]? then transform attrs
  m selector, attrs, children

extensions =
  binds: (attrs) ->
    [handlerName, attrName, getterSetter] = attrs.binds
    attrs[attrName] = getterSetter()
    attrs[handlerName] = m.withAttr attrName, getterSetter
    delete attrs.binds


## bindComponent

exports.bindComponent =
bindComponent = (component, attrs, children) ->
  bound =
    view: (ctlr) -> component.view ctlr, attrs, children

  if component.controller
    bound.controller = -> new component.controller attrs, children

  bound


## table

exports.table =
table = ([keys, rows...]) ->
  toObject = objectFactory keys
  rows.map toObject

objectFactory = (keys) ->
  (values) ->
    obj = {}
    for key, index in keys
      obj[key] = values[index]
    obj
