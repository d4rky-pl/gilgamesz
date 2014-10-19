class Editor.Sidebar.Base
  template: ''

  constructor: (editor, container) ->
    @editor = editor
    @container = $(container)

  render: ->
    @beforeRender()
    @container.html(JST['editor/' + @template](@context()))
    @afterRender()

  context: ->
    {}

  beforeRender: ->
  afterRender: ->