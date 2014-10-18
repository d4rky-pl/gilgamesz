class Adventure
  constructor: (container, adventure) ->
    @settings = adventure.settings
    @nodes    = @prepareNodes(adventure.nodes)
    @items    = @prepareItems(adventure.items)

    @_inventory = new AdventureInventory(this)
    @_renderer  = new AdventureRenderer(this, $(container))

    @start_node = adventure.nodes[0]

  prepareNodes: (nodes) ->
    node_list = {}
    nodes.each (node) ->
      node_list[node.id] = node
    node_list

  prepareItems: (items) ->
    item_list = {}
    items.each (item) ->
      item_list[item.id] = item
    item_list

  start: ->
    @_current_node = @start_node
    @render()

  render: ->
    @_renderer.render(@_current_node)

  moveTo: (node) ->
    @_current_node = node
    @render()



class AdventureRenderer
  constructor: (adventure, container) ->
    @adventure = adventure
    @container = container

  render: (node, event) ->
    template = JST['show/template'](@getContextForNode(node, event))
    @container.empty()
    @container.html(template)
    $('[data-toggle="popover"]', @container).popover()

  getContextForNode: (node, event) ->
    context = {
      game_name: @adventure.settings.name
      type: node.type
    }

    if event
      context.message = node.events[event].description
      context.actions = node.events[event].actions
    else
      context.message = node.description
      context.actions = node.actions

    if node.type == 'add_item' || (node.type == 'use_item' && event == 'use_item')
      context.item = @adventure.items[node.item_id]

    context.inventory = @adventure._inventory.all()
    context



class AdventureInventory
  constructor: (adventure) ->
    @adventure = adventure
    @inventory = []

  add: (item) ->
    @inventory.push(item)

  remove: (item) ->
    item_index = @_itemIndex(id)
    @inventory.delete item_index if item_index != -1

  get: (id) ->
    item_index = @_itemIndex(id)
    @inventory[item_index] if item_index != -1

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

window.Adventure = Adventure
