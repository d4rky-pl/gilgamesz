class Game.Renderer
  constructor: (game, container) ->
    @game = game
    @container = container

  render: (state) ->
    self = this

    template = JST['game/template'](@getContextForNode(state))
    @container.empty()
    @container.html(template)
    $('[data-toggle="popover"]', @container).popover({ html: true })

    $('[data-action="move"]', @container).click ->
      self.game.move($(this).data('node-id'))

    $('[data-action="restart"]', @container).click ->
      self.game.restart()

  getContextForNode: (state) ->
    node = state.node
    event = state.event

    context = {
      game_name: @game.settings.name
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
      context.item = @game.items[node.item_id]

    if node.type == 'finish' || node.type == 'gameover'
      context.game_over = true

    context.inventory = @game.state.inventory.all()
    context