'use strict'

m = require 'mithril'


module.exports =


  ## bindComponent

  bindComponent: (component, attrs, children) ->
    bound =
      view: (ctlr) -> component.view ctlr, attrs, children
    if component.controller
      bound.controller = -> new component.controller attrs, children
    bound


  ## connectComponent

  connectComponent: do ->
    defaultMapStateToAttrs = -> {}

    connectComponent = (component, mapStateToAttrs = defaultMapStateToAttrs) ->
      getAttrs = (store) ->
        attrs = mapStateToAttrs store.getState()
        attrs.dispatch = store.dispatch
        attrs

      connected =
        view: (ctlr, {store}, children) ->
          component.view ctlr, getAttrs(store), children
      if component.controller
        connected.controller = ({store}, children) ->
          new component.controller getAttrs(store), children
      connected
