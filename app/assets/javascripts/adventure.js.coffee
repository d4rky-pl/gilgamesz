class Adventure
  constructor: (container, adventure) ->
    @renderer  = new AdventureRenderer(this, $(container))

    @settings = adventure.settings
    @nodes    = @prepareNodes(adventure.nodes)
    @items    = @prepareItems(adventure.items)

    @start_node = adventure.nodes[0]

  prepareNodes: (nodes) ->
    node_list = {}
    nodes.each (node) ->
      node_list[node.id] = node
    node_list

  prepareItems: (items) ->
    item_list = {}
    items.each (item) ->
      item.image = asset_path("items/#{item.image}")
      item_list[item.id] = item
    item_list

  start: ->
    @state = {
      inventory: new AdventureInventory(this)
      node:      @start_node
      event:     null
      past:      {}
    }
    @move(@start_node)

  restart: ->
    @start()

  move: (node) ->
    node = @nodes[node] unless node.id?
    @state.node = node
    @state.event = null
    @react()
    @render()

  react: ->
    if AdventureReactions[@state.node.type]?
      AdventureReactions[@state.node.type].call(this)


  render: ->
    @renderer.render(@state)


  # HELPER METHODS
  addItem: ->
    @state.inventory.add(@state.node.item_id)

  removeItem: ->
    @state.inventory.remove(@state.node.item_id)

  hasItem: ->
    @state.inventory.has(@state.node.item_id)

  this_already_happened: ->
    !!@state.past[@state.node.id]

  happened: ->
    @state.past[@state.node.id] = true



class AdventureRenderer
  constructor: (adventure, container) ->
    @adventure = adventure
    @container = container

  render: (state) ->
    self = this

    template = JST['show/template'](@getContextForNode(state))
    @container.empty()
    @container.html(template)
    $('[data-toggle="popover"]', @container).popover({ html: true })

    $('[data-action="move"]', @container).click ->
      self.adventure.move($(this).data('node-id'))

    $('[data-action="restart"]', @container).click ->
      self.adventure.restart()

  getContextForNode: (state) ->
    node = state.node
    event = state.event

    context = {
      game_name: @adventure.settings.name
      type: node.type
      event: event
    }

    if event?
      context.message = node.events[event].description
      context.actions = node.events[event].actions
    else
      context.message = node.description
      context.actions = node.actions

    if event == 'add_item' || event == 'use_item'
      context.item = @adventure.items[node.item_id]

    if node.type == 'finish' || node.type == 'gameover'
      context.game_over = true

    context.inventory = @adventure.state.inventory.all()
    context



class AdventureInventory
  constructor: (adventure) ->
    @adventure = adventure
    @inventory = []

  add: (id) ->
    @inventory.push(@adventure.items[id])

  remove: (id) ->
    item_index = @_itemIndex(id)
    @inventory.delete item_index if item_index != -1

  get: (id) ->
    item_index = @_itemIndex(id)
    @inventory[item_index] if item_index != -1

  has: (id) ->
    item_index = @_itemIndex(id)
    item_index != -1

  all: ->
    @inventory

  _itemIndex: (id) ->
    item_index = -1
    @inventory.each (item, i) ->
      if item.id == id
        item_index = i
        false
      else
        true

    item_index



AdventureReactions = {
  passage: ->
    @state.event = undefined

  add_item: ->
    if @this_already_happened()
      @state.event = 'already_has_item'

    else
      @state.event = 'add_item'
      @addItem()
      @happened()

  use_item: ->
    if @this_already_happened()
      @state.event = 'already_used_item'

    else if @state.inventory.has(@state.node.item_id)
      @state.event = 'use_item'
      @removeItem() if @state.node.remove_after
      @happened()

    else
      @state.event = 'no_item'

  finish: ->

  gameover: ->

}


window.Adventure = Adventure
