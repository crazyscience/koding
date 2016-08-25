kd = require 'kd'
React = require 'react'
SidebarStackSection = require 'lab/SidebarStackSection'
SidebarStackHeaderSection = require 'app/components/sidebarstacksection/sidebarstackheadersection'
SidebarNoStacks = require 'app/components/sidebarstacksection/sidebarnostacks'


module.exports = class Sidebar extends React.Component


  PREVIEW_COUNT = 10

  renderStack: (stack) ->
    machines = @props.stacksWithMachines[stack._id] or []
    template = @props.stacksWithTemplates[stack._id] or {}
    <SidebarStackSection
      key={stack._id}
      stack={stack}
      template={template}
      machines={machines}
      reinitStack={@props.reinitStack}/>


  renderPrivateStacks: ->
    @props.privateStacks.map (stack) => @renderStack stack


  renderTeamStacks: ->
    @props.teamStacks.map (stack) => @renderStack stack


  renderStacks : ->

    if @props.stacks
      <SidebarStackHeaderSection>
        {@renderTeamStacks()}
        {@renderPrivateStacks()}
      </SidebarStackHeaderSection>
    else
      <SidebarNoStacks />


  renderDrafts: ->

    return  unless @props.draftStackTemplates

    @props.draftStackTemplates.map (draftStackTemplate) =>
      @renderStack draftStackTemplate


  render: ->

    <div className='Sidebar-section-wrapper'>
      {@renderStacks()}
      {@renderDrafts()}
    </div>
