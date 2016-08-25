kd = require 'kd'
React = require 'react'
immutable = require 'app/util/immutable'
Immutable = require 'seamless-immutable'
SidebarMachinesListItem = require 'lab/SidebarMachinesListItem'
EnvironmentFlux = require 'app/flux/environment'
MENU = null
isAdmin = require 'app/util/isAdmin'


module.exports = class SidebarStackSection extends React.Component

  @propTypes =
    stack: React.PropTypes.object
    menuItems: React.PropTypes.object
    updated: React.PropTypes.bool
    machines: React.PropTypes.array

  @defaultProps =
    stack : {}
    menuItems: {}
    updated: no
    machines: []


  showMenuItems: (event) ->
    kd.utils.stopDOMEvent event
    { stack, machines }  = @props


    if machines.length
      @prepareStackTitleMenu()
    else
      @prepareDraftStackTitleMenu()


  onMenuDraftItemClick: (item, event) ->

    MENU.destroy()
    { router } = kd.singletons
    { stack } = @props
    { title } = item.getData()
    switch title
      when 'Edit' then router.handleRoute "/Stack-Editor/#{stack._id}"
      when 'Initialize'
        EnvironmentFlux.actions.generateStack(stack._id).then ({ template }) ->
          kd.singletons.appManager.tell 'Stackeditor', 'reloadEditor', template._id


  onMenuItemClick: (item, event) ->

    { appManager, router, computeController } = kd.singletons
    { stack, template } = @props
    { reinitStackFromWidget, deleteStack } = EnvironmentFlux.actions

    { title } = item.getData()
    MENU.destroy()

    templateId = stack.baseStackId

    switch title
      when 'Edit' then router.handleRoute "/Stack-Editor/#{templateId}"
      when 'Reinitialize', 'Update'
        @props.reinitStack stack, template

      when 'Destroy VMs' then @props.destroyStack stack
      when 'VMs' then router.handleRoute "/Home/Stacks/virtual-machines"



  prepareStackTitleMenu: ->

    return  if MENU


    callback = (item, event) => @onMenuItemClick item, event

    menuItems = {}

    if @getStackUnreadCount()
      menuItems['Update'] = { callback }

    managedVM = @props.stack.title.indexOf('Managed VMs') > -1

    if managedVM
      menuItems['VMs'] = { callback }
    else
      menuItems['Edit'] = { callback }  if isAdmin()
      ['Reinitialize', 'VMs', 'Destroy VMs'].forEach (name) ->
        menuItems[name] = { callback }

    menuOptions = { cssClass: 'SidebarMenu', x: 36, y: 102 + 31 }

    MENU = new kd.ContextMenu menuOptions, menuItems

    MENU.once 'KDObjectWillBeDestroyed', -> kd.utils.wait 50, -> MENU = null


  getStackUnreadCount: ->
    @props.stack.getAt [ '_revisionStatus', 'status', 'code' ]


  prepareDraftStackTitleMenu: ->

    return  if MENU

    callback = (item, event) => @onMenuDraftItemClick item, event

    menuItems = {}
    ['Edit', 'Initialize'].forEach (name) => menuItems[name] = { callback }


    menuOptions = { cssClass: 'SidebarMenu', x: 36, y: 500 + 31 }

    MENU = new kd.ContextMenu menuOptions, menuItems

    MENU.once 'KDObjectWillBeDestroyed', -> kd.utils.wait 50, -> MENU = null






  renderUpdateIcon: ->
    return  unless @props.updated
    console.log 'renderUpdateIcon'


  renderMachines: ->

    @props.machines.map (machine) ->
      <SidebarMachinesListItem key={machine._id} machine={machine}/>


  render: ->

    <div className='SidebarStackSection'>
      {@renderUpdateIcon()}
      <div className='SidebarStackSection--title' onClick={@showMenuItems.bind(this)}>
        {@props.stack.title}
      </div>
      {@renderMachines()}
    </div>
