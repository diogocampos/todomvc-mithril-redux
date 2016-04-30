'use strict'

m = require 'mithril'


module.exports =

  ## KeyCode

  KeyCode:
    ENTER: 13
    ESCAPE: 27


  ## createComponent

  createComponent: do ->
    createComponent = (cls) ->
      controller: (attrs, children) ->
        cls::setAttrs or= (@attrs, @children) -> # no-op
        new cls attrs, children

      view: (ctlr, attrs, children) ->
        ctlr.setAttrs attrs, children
        ctlr.render()


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
