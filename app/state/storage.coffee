'use strict'


DEFAULT_KEY = 'redux-state'

identity = (x) -> x


exports.attachStorage = (options) ->
  { storage = localStorage
    key = DEFAULT_KEY
    fromStorage = identity
    toStorage = identity
  } = options

  (nextStoreCreator) -> (reducer, defaultState) ->
    # Load:  state = fromStorage JSON.parse storage.getItem key
    # Save:  storage.setItem key, JSON.stringify toStorage state

    json = storage.getItem key
    initialState = if json? \
      then fromStorage JSON.parse json
      else defaultState

    store = nextStoreCreator reducer, initialState
    lastValue = if json? \
      then toStorage initialState
      else null

    saveIfChanged = ->
      value = toStorage store.getState()
      return if value is lastValue
      lastValue = value

      try
        storage.setItem key, JSON.stringify value
      catch err
        console.error "Can't save", err

    store.subscribe saveIfChanged
    store
