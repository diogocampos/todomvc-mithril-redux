'use strict'

m = require 'mithril'


module.exports =


  ## bindComponent

  bindComponent: (component, attrs, children) ->
    wrapComponent component,
      controller: -> new component.controller attrs, children
      view: (ctlr) -> component.view ctlr, attrs, children


  ## connectComponent

  connectComponent: do ->
    defaultMapStateToAttrs = -> {}

    connectComponent = (component, mapStateToAttrs = defaultMapStateToAttrs) ->
      getAttrs = (store) ->
        attrs = mapStateToAttrs store.getState()
        attrs.dispatch = store.dispatch
        attrs

      wrapComponent component,
        controller: ({store}, children) ->
          new component.controller getAttrs(store), children
        view: (ctlr, {store}, children) ->
          component.view ctlr, getAttrs(store), children


## Helpers

wrapComponent = (component, {controller, view}) ->
  wrapped =
    view: view or component.view
  if component.controller
    wrapped.controller = controller or component.controller
  wrapped
