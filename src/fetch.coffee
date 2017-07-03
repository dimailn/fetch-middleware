_       = require 'lodash'
axios   = require 'axios'
Promise = require './utils/promise'

module.exports = (store) -> (next) -> (action) ->
  { dispatch } = store

  return next(action) unless action.types and action.meta?.fetch

  action = _.cloneDeep action
  { fetch } = action.meta
  delete action.meta.fetch

  fetch = url: fetch if typeof fetch is 'string'
  fetch.method ?= 'GET'

  action.payload = axios(fetch)
    .then(
      (result) -> Promise.resolve result.data
      (result) -> Promise.reject result.data
    )

  next action
