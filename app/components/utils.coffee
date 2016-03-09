'use strict'

m = require 'mithril'


module.exports =

  ## KeyCode

  KeyCode:
    ENTER: 13
    ESCAPE: 27


  ## bindComponent

  bindComponent: (component, attrs, children) ->
    view: -> m component, attrs, children


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
