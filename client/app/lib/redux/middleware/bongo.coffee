_ = require 'lodash'

module.exports = bongoMiddleware = (remote) -> (store) -> (next) -> (action) ->

  return next action  unless action.bongo

  { bongo, type, types } = action
  rest = _.omit action, ['bongo', 'type', 'types']

  next
    types: generateTypes()
    promise: -> bongo(remote, { getState: store.getState })


generateTypes = -> [
  "BONGO_BEGIN"
  "BONGO_SUCCESS"
  "BONGO_FAIL"
]
