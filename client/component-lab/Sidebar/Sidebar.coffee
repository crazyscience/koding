kd = require 'kd'
React = require 'react'
SidebarStackSection = require 'app/components/sidebarstacksection'
SidebarStackHeaderSection = require 'app/components/sidebarstacksection/sidebarstackheadersection'
SidebarNoStacks = require 'app/components/sidebarstacksection/sidebarnostacks'
toImmutable = require 'app/util/toImmutable'


module.exports = class Sidebar extends React.Component

  PREVIEW_COUNT = 10

  renderStack: (stack) ->
    stack = toImmutable stack
    <SidebarStackSection
      key={stack.get '_id'}
      previewCount={PREVIEW_COUNT}
      selectedId={0}
      stack={stack}
      machines={stack.get 'machines'}/>


  renderPrivateStacks: ->
    @props.privateStacks.map (stack) => @renderStack stack


  renderTeamStacks: ->
    @props.teamStacks.map (stack) => @renderStack stack


  renderStacks : ->

    if @props.stacks
      console.log 'HAYDAADA'
      <SidebarStackHeaderSection>
        {@renderTeamStacks()}
        {@renderPrivateStacks()}
      </SidebarStackHeaderSection>
    else
      <SidebarNoStacks />


  render: ->
    stacks = @renderStacks()
    <div className='Sidebar-section-wrapper'>
      {stacks}
    </div>
