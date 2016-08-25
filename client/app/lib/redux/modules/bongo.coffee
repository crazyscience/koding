immutable = require 'app/util/immutable'
kd = require 'kd'

module.exports = bongo = (state = immutable({}), action) ->

  switch action.type
    when 'BONGO_SUCCESS'

      { result } = action
      result = [result]  unless Array.isArray result
      result.forEach (res) ->

        state = state.set res.constructor.name, immutable {}  unless state[res.constructor.name]
        state = state.update res.constructor.name, (collection) ->
          collection.set res._id, immutable res

      return state

    when 'BONGO_DELETE_SUCCESS'

      { result: { _id, constructorName } } = action
      state = state.set constructorName, state[constructorName].without("#{_id}")

      return state

    else

      return state


exports.loadAll = loadAll = (constructorName) ->
  return {
    bongo: (remote) -> remote.api[constructorName].some({})
  }


exports.update = update = (instance, query) ->
  return {
    bongo: -> instance.update query
  }


module.exports.deleteInstance = deleteX = (instance) ->
  return {
    type: 'BONGO_DELETE'
    bongo: -> instance.delete().then ->
      { result: { constructorName: instance.constructor.name, _id: instance._id } }
  }


exports.load = load = (constructorName, _id) ->
  return {
    bongo: (remote) -> remote.api[constructorName].one { _id }
  }


bongo = (state) -> state.bongo


module.exports.byId = (constructorName, id) -> (state) -> state.bongo[constructorName][id]


module.exports.all = (constructorName) -> (state) -> state.bongo[constructorName]


module.exports.reinitStack = (stack, template) ->

  return  unless template

  { computeController } = kd.singletons

  groupStack = stack.config?.groupStack
  computeController.destroyStack stack, (err) ->
    #delete instance event should be cathced in the bongo middleware
    if template and not groupStack
    then computeController.createDefaultStack no, template
    else computeController.createDefaultStack()

module.exports.destroyStack = (stack) ->

  return  unless stack

