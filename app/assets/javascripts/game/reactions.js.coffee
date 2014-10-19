Game.Reactions =
  passage: ->
    @state.event = undefined

  add_item: ->
    if @helpers.this_already_happened()
      @state.event = 'already_has_item'

    else
      @state.event = 'add_item'
      @helpers.addItem()
      @helpers.happened()

  use_item: ->
    if @helpers.this_already_happened()
      @state.event = 'already_used_item'

    else if @helpers.hasItem()
      @state.event = 'use_item'
      @helpers.removeItem() if @state.node.remove_after
      @helpers.happened()

    else
      @state.event = 'no_item'

  finish: ->

  gameover: ->