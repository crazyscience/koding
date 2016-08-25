React = require 'react'
{ connect } = require 'react-redux'
Sidebar = require 'component-lab/Sidebar'

{ reinitStack
  destroyStack } = require 'app/redux/modules/bongo'

{ privateStackTemplates
  teamStackTemplates
  privateStacks
  teamStacks
  stacksWithMachines
  stacksWithTemplates
  draftStackTemplates } = require 'app/redux/selectors/sidebar'


mapDispatchToProps = (dispatch) ->

  return {
    reinitStack: (stack, template) ->
      reinitStack stack, template
    destroyStack: (stack) ->
      destroyStack stack
  }

mapStateToProps = (state) ->

  return {
    stacks: state.bongo['JComputeStack']
    privateStacks: privateStacks(state.bongo['JComputeStack']) or {}
    teamStacks: teamStacks(state.bongo['JComputeStack']) or {}
    stacksWithMachines: stacksWithMachines(state.bongo['JComputeStack'], state.bongo['JMachine'])
    stacksWithTemplates: stacksWithTemplates(state.bongo['JComputeStack'], state.bongo['JStackTemplate'])
    draftStackTemplates: draftStackTemplates(state.bongo['JStackTemplate'])
  }


class SidebarContainer extends React.Component

  componentWillMount: ->

    @props.store.dispatch({ bongo: (remote) -> remote.api.JMachine.some({}) })
    @props.store.dispatch({ bongo: (remote) -> remote.api.JStackTemplate.some({}) })
    @props.store.dispatch({ bongo: (remote) -> remote.api.JComputeStack.some({}) })


  render: ->

    <Sidebar
      stacks={@props.stacks}
      teamStacks={@props.teamStacks}
      privateStacks={@props.privateStacks}
      stacksWithMachines={@props.stacksWithMachines}
      stacksWithTemplates={@props.stacksWithTemplates}
      draftStackTemplates={@props.draftStackTemplates}
      reinitStack={@props.reinitStack} />


module.exports = connect(mapStateToProps, mapDispatchToProps)(SidebarContainer)
