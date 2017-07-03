{Promise} = require 'es6-promise'

Promise.ensure = (value) ->
  if value and typeof value.then is 'function'
    if value instanceof Promise
      value
    else
      new Promise (resolve, reject) -> value.then(resolve, reject)
  else
    Promise.resolve value

Promise::finally = (cb) ->
  @then( cb
    (error) ->
      cb(error)
      Promise.reject(error)
  )

Promise::tap = (cb) ->
  @then (value) ->
    cb(value)
    value

Promise::tapError = (cb) ->
  @catch (error) ->
    cb(error)
    Promise.reject(error)

module.exports = Promise
