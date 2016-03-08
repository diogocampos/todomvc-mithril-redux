'use strict'

{actionCreator} = require './utils'


## Action Creators

exports.actions =
  setFilter: actionCreator 'SET_FILTER', 'filter'


## Reducer

initialFilter = 'all'

exports.reducer = (filter = initialFilter, action) ->
  switch action.type
    when 'SET_FILTER' then action.filter
    else filter
