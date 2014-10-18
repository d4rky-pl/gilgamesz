class Editor
  GAME_TYPES: ['fantasy','scifi','detective']

  constructor: (container, adventure) ->
    @container = $(container)
    @container.html(JST['edit/template']())

    @adventure = adventure
    @sidebar = new Editor.Sidebar(this, '#sidebar')

    window._editor = this

  render: ->
    @sidebar.render()



class Editor.Sidebar
  constructor: (editor, container) ->
    @editor = editor
    @container = $(container)

    @container.html(JST['edit/sidebar']())

    @tabs = {
      node:      new Editor.Sidebar.Node(@editor, '#sidebar-node'),
      inventory: new Editor.Sidebar.Inventory(@editor, '#sidebar-inventory'),
      settings:  new Editor.Sidebar.Settings(@editor, '#sidebar-settings')
    }

  render: ->
    @tabs.node.render()
    @tabs.inventory.render()
    @tabs.settings.render()


class Editor.Sidebar.Base
  template: ''

  constructor: (editor, container) ->
    @editor = editor
    @container = $(container)

  render: ->
    @beforeRender()
    @container.html(JST['edit/' + @template](@context()))
    @afterRender()

  context: ->
    {}

  beforeRender: ->
  afterRender: ->


class Editor.Sidebar.Node extends Editor.Sidebar.Base
  template: 'node/passage'



class Editor.Sidebar.Inventory extends Editor.Sidebar.Base
  template: 'inventory'

  


class Editor.Sidebar.Settings extends Editor.Sidebar.Base
  template: 'settings'

  context: ->
    {
      adventure: @editor.adventure,
      game_types: @editor.GAME_TYPES
    }

  afterRender: ->
    self = this
    $("input, select, textarea", @container).change ->
      $this = $(this)
      name = $this.attr('name')
      field = name.match(/\[(.*)\]/)[1]
      console.log(field, $this.val())
      self.editor.adventure.settings[field] = $this.val()

window.Editor = Editor