kd = require 'kd'
React = require 'react'
Link  = require 'app/components/common/link'


module.exports = class SidebarMachinesListItem extends React.Component

  @propTypes =
    machine: React.PropTypes.object

  @defaultProps =
    machine : {}


  render: ->

    return  unless @props.machine

    { label, slug, _id } = @props.machine

    <div className='SidebarMachinesListItem'>
      <Link
        className='SidebarMachinesListItem--title'
        key={_id}
        href="/IDE/#{label or slug}" >
        {label}
      </Link>
    </div>
