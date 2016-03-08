'use strict'

{actionCreator} = require './utils'


## Action Creators

exports.filterActions =
  setFilter: actionCreator 'SET_FILTER', 'filter'


## Reducer

initialFilter = 'all'

exports.filterReducer = (filter = initialFilter, action) ->
  switch action.type
    when 'SET_FILTER' then action.filter
    else filter
