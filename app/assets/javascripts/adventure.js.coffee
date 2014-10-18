class Adventure
  initialize: (adventure) ->
    @settings = adventure.settings
    @nodes    = prepareNodes(adventure.nodes)
    @items    = prepareItems(adventure.items)

  prepareNodes: (nodes) ->


  prepareItems: (items) ->


  start: ->
    # Initialize game
    @inventory = []

  addItemToInventory: (item_id) ->



window.Adventure = Adventure
