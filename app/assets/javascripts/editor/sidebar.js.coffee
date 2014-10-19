class Editor.Sidebar
  constructor: (editor, container) ->
    @editor = editor
    @container = $(container)

    @container.html(JST['editor/sidebar']())

    @tabs = {
      node:      new Editor.Sidebar.Node(@editor, '#sidebar-node'),
      inventory: new Editor.Sidebar.Inventory(@editor, '#sidebar-inventory'),
      settings:  new Editor.Sidebar.Settings(@editor, '#sidebar-settings')
    }

  render: ->
    @tabs.node.render()
    @tabs.inventory.render()
    @tabs.settings.render()