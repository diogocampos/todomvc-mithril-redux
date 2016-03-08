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


  ## KeyCode

  KeyCode:
    ENTER: 13
    ESCAPE: 27


  ## mx

  mx: do ->
    extensions =
      binds: (attrs) ->
        [handlerName, attrName, getterSetter] = attrs.binds
        attrs[attrName] = getterSetter()
        attrs[handlerName] = m.withAttr attrName, getterSetter
        delete attrs.binds

    mx = (selector, attrs, children) ->
      for key, transform of extensions
        if attrs[key]? then transform attrs
      m selector, attrs, children
