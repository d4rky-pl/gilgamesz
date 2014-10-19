class Game.Helpers
  constructor: (game) ->
    @game = game
    @state = @game.state

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
