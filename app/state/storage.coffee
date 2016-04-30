'use strict'


DEFAULT_KEY = 'redux-state'

identity = (x) -> x


exports.attachStorage = (options) ->
  { storage = window.localStorage
    key = DEFAULT_KEY
    fromStorage = identity
    toStorage = identity
  } = options

  (nextStoreCreator) -> (reducer, defaultState) ->
    # Load:  state = fromStorage JSON.parse storage.getItem key
    # Save:  storage.setItem key, JSON.stringify toStorage state

    json = storage.getItem key
    if json?
      lastValue = JSON.parse json
      initialState = fromStorage lastValue
    else
      lastValue = null
      initialState = defaultState

    store = nextStoreCreator reducer, initialState

    store.subscribe saveIfChanged = ->
      value = toStorage store.getState()
      return if value is lastValue
      lastValue = value
      try
        storage.setItem key, JSON.stringify value
      catch err
        console.error "Can't save", err

    store
