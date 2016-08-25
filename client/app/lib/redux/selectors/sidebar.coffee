immutable = require 'app/util/immutable'

Object.values = (obj) ->

  Object.keys(obj).map (key) -> obj[key]


privateStackTemplates = (stackTemplates) ->

  return null  unless stackTemplates

  Object.values(stackTemplates).filter (template) ->
    template.accessLevel is 'private'


privateStacks = (stacks) ->

  return null  unless stacks

  Object.values(stacks).filter (stack) ->
    not stack.getAt(['config', 'groupStack'])


teamStackTemplates = (stackTemplates) ->

  return null  unless stackTemplates

  Object.values(stackTemplates).filter (template) ->
    template.accessLevel is 'group'


teamStacks =  (stacks) ->

  return null  unless stacks

  Object.values(stacks).filter (stack) ->
    stack.getAt(['config', 'groupStack'])


draftStackTemplates = (stackTemplates) ->

  return null  unless stackTemplates

  Object.values(stackTemplates).filter (template) ->
    not template.machines.length


stacksWithMachines = (stacks, machines) ->

  return null  if not stacks or not machines

  stacksWithMachines = {}
  Object.values(stacks).forEach (stack) ->
    stacksWithMachines[stack._id] = []
    stack.machines.forEach (machineId) ->
      stacksWithMachines[stack._id].push immutable machines[machineId]

  return stacksWithMachines


stacksWithTemplates = (stacks, stackTemplates) ->

  return null if not stacks or not stackTemplates

  stacksWithTemplates = {}
  Object.values(stacks).forEach (stack) ->
    baseStackId = stack.baseStackId
    if baseStackId
      stacksWithTemplates[stack._id] = stackTemplates["#{baseStackId}"]

  return stacksWithTemplates


module.exports = {
  privateStackTemplates
  privateStacks
  teamStackTemplates
  teamStacks
  stacksWithMachines
  draftStackTemplates
  stacksWithTemplates
}
