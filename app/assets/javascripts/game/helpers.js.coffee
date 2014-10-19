class Game.Helpers
  constructor: (game) ->
    @game = game

  addItem: ->
    @game.state.inventory.add(@game.state.node.item_id)

  removeItem: ->
    @game.state.inventory.remove(@game.state.node.item_id)

  hasItem: ->
    @game.state.inventory.has(@game.state.node.item_id)

  this_already_happened: ->
    !!@game.state.past[@game.state.node.id]

  happened: ->
    @game.state.past[@game.state.node.id] = true
