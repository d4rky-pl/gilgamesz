class Editor
  GAME_TYPES: ['fantasy','scifi','detective']

  constructor: (container, adventure) ->
    @container = $(container)
    @container.html(JST['editor/template']())

    @adventure = adventure
    @sidebar = new Editor.Sidebar(this, '#sidebar')
    @graph   = new Graph(this, '#graph')

    window._editor = this

  selectNode: (id) ->
    @sidebar.tabs.node.setNode(id)

  render: ->
    @sidebar.render()
    @graph.render()

window.Editor = Editor