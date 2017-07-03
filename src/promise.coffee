_ = require 'lodash'
Promise = require './utils/promise'
isPromise = (obj) -> typeof obj.then is 'function'

module.exports = ({dispatch}) -> (next) -> (action) ->
  unless action.types and isPromise(action.payload)
    return next(action)

  [PENDING, SUCCESS, FAILURE] = if Array.isArray action.types
    action.types
  else if typeof action.types is 'object'
    [action.types.load, action.types.success, action.types.failure]
  else
    throw new Error("Can't handle action types: #{action.types}")
  next { type: PENDING, meta: action.meta }

  Promise.ensure(action.payload).then(
    (result) ->
      dispatch { type: SUCCESS, payload: result.data, response: result, meta: _.extend action.meta, {done: true} }
      result

    (error) ->
      dispatch { type: FAILURE, payload: error.data, response: error, error: true, meta: _.extend action.meta, {done: true} }
      Promise.reject error
  )