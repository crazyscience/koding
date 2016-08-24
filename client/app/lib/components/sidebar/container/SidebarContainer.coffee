React = require 'react'
{ connect } = require 'react-redux'
Sidebar = require 'component-lab/Sidebar'
{ privateStackTemplates, teamStackTemplates, privateStacks, teamStacks } = require 'app/redux/modules/bongo'


mapStateToProps = (state) ->
  return {
    stackTemplates: state.bongo['JStackTemplate']
    stacks: state.bongo['JComputeStack']
    group: state.bongo['JGroup']
    privateStacks: privateStacks(state.bongo['JComputeStack'])
    teamStacks: teamStacks(state.bongo['JComputeStack'])
    privateStackTemplates: privateStackTemplates(state.bongo['JStackTemplate'])
    teamStackTemplates: teamStackTemplates(state.bongo['JStackTemplate'])
  }


class SidebarContainer extends React.Component

  componentDidMount: ->
    @props.dispatch({ bongo: (remote) -> remote.api.JStackTemplate.some({}) })
    @props.dispatch({ bongo: (remote) -> remote.api.JComputeStack.some({}) })


  render: ->

    <Sidebar
      stacks={@props.stacks}
      teamStacks={@props.teamStacks}
      privateStacks={@props.privateStacks}  />


module.exports = connect(mapStateToProps)(SidebarContainer)
