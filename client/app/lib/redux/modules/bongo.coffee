immutable = require 'app/util/immutable'
{ createSelector } = require 'reselect'

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


exports.delete = deleteX = (instance) ->
  return {
    bongo: -> instance.delete()
  }


exports.load = load = (constructorName, _id) ->
  return {
    bongo: (remote) -> remote.api[constructorName].one { _id }
  }


bongo = (state) -> state.bongo


module.exports.byId = (constructorName, id) -> (state) -> state.bongo[constructorName][id]


module.exports.all = (constructorName) -> (state) -> state.bongo[constructorName]


module.exports.privateStackTemplates = (stackTemplates) ->

  privateStackTemplates = []
  return null  unless stackTemplates
  for id in Object.keys(stackTemplates)
    if stackTemplates[id].accessLevel is 'private'
      privateStackTemplates.push stackTemplates[id]

  return privateStackTemplates

module.exports.privateStacks = (stacks) ->

  privateStacks = []
  return null  unless stacks
  for id in Object.keys(stacks)
    unless stacks[id].config.groupStack
      privateStacks.push stacks[id]

  return privateStacks

module.exports.teamStackTemplates =  (stackTemplates) ->

  teamStackTemplates = []
  return null  unless stackTemplates
  for id in Object.keys(stackTemplates)
    if stackTemplates[id].accessLevel is 'group'
      teamStackTemplates.push stackTemplates[id]

  return teamStackTemplates

module.exports.teamStacks =  (stacks) ->

  teamStacks = []
  return null  unless stacks
  for id in Object.keys(stacks)
    if stacks[id].config.groupStack
      teamStacks.push stacks[id]

  return teamStacks

