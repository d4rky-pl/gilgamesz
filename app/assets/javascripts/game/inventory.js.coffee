class Game.Inventory
  constructor: (game) ->
    @game = game
    @inventory = []

  add: (id) ->
    @inventory.push(@game.items[id])

  remove: (id) ->
    item_index = @_itemIndex(id)
    delete @inventory[item_index] if item_index != -1

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
