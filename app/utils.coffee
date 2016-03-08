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


