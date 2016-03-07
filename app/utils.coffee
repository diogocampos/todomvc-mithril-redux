'use strict'

m = require 'mithril'


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


## mx.boundComponent

mx.boundComponent = (component, attrs, children) ->
  bound =
    view: (ctlr) -> component.view ctlr, attrs, children

  if component.controller?
    bound.controller = -> new component.controller attrs, children

  bound


## mx.select

mx.select = (element, isInitialized, context) ->
  element.select() unless isInitialized


## boundMethods

exports.boundMethods =
boundMethods = (obj) ->
  methods = {}
  for key, fn of obj when typeof fn is 'function'
    methods[key] = fn.bind obj
  methods


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


## UUIDv4

exports.UUIDv4 = do ->
  ranges = [[0, 8], [8, 12], [12, 16], [16, 20], [20, 32]]
  version = 12
  variant = 16

  UUIDv4 = ->
    bytes = crypto.getRandomValues new Uint8Array 32

    digits = (byte % 16 for byte in bytes)
    digits[version] = 4
    digits[variant] = 8 + digits[variant] % 4

    hexDigits = (digit.toString 16 for digit in digits)

    sections = (hexDigits.slice(range...).join('') for range in ranges)
    sections.join('-')
