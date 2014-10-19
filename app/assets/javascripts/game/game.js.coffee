class Game
  constructor: (container, adventure) ->
    @renderer  = new Game.Renderer(this, $(container))
    @helpers   = new Game.Helpers(this)

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
      inventory: new Game.Inventory(this)
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
    if Game.Reactions[@state.node.type]?
      Game.Reactions[@state.node.type].call(this)

  render: ->
    @renderer.render(@state)

window.Game = Game
