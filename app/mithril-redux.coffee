'use strict'

m = require 'mithril'


module.exports =

  bindComponent: (component, attrs, children) ->
    wrapComponent component,
      controller: -> new component.controller attrs, children
      view: (ctlr) -> component.view ctlr, attrs, children


## Helpers

wrapComponent = (component, {controller, view}) ->
  wrapped =
    view: view or component.view
  if component.controller
    wrapped.controller = controller or component.controller
  wrapped
