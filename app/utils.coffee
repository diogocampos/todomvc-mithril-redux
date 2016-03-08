'use strict'

m = require 'mithril'


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
