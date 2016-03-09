'use strict'


identity = (state) -> state

$SAVE = {}


module.exports =

  middleware: ({storage = localStorage, key, selector = identity}) ->
    ({dispatch, getState}) -> (next) -> (action) ->
      if action is $SAVE
        try
          data = JSON.stringify selector getState()
          storage.setItem key, data
        catch err
          console.error "Can't save", err
      else
        next action


  $saves: (actionCreator) -> (args...) ->
    (dispatch) ->
      result = dispatch actionCreator(args...)
      dispatch $SAVE
      result
