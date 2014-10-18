class Editor
  GAME_TYPES: ['fantasy','scifi','detective']

  constructor: (container, adventure) ->
    @container = $(container)
    @container.html(JST['edit/template']())

    @adventure = adventure
    @sidebar = new Editor.Sidebar(this, '#sidebar')

    window._editor = this

  selectNode: (id) ->
    @sidebar.tabs.node.setNode(id)

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
  current: null

  constructor: (editor, container) ->
    super
    @current = @editor.adventure.nodes[0]

  setNode: (id) ->
    node_index = @_nodeIndex(id)
    @current = @editor.adventure.nodes[node_index]
    @render()

  context: ->
    {
      id: @current.id
    }

  beforeRender: ->
    @template = "node/#{@current.type}"

  _nodeIndex: (id) ->
    node_index = -1
    @editor.adventure.nodes.each (node, i) ->
      if node.id == id
        node_index = i
        false
      else
        true
    node_index


class Editor.Sidebar.Inventory extends Editor.Sidebar.Base
  template: 'inventory'

  context: ->
    {
      items: @editor.adventure.items,
      available_images: gon.available_images
    }

  afterRender: ->
    self = this
    $('[data-action="remove-item"]', @container).click ->
      $this = $(this)
      id = $this.data('item-id')
      bootbox.dialog(
        title: 'Are you sure you want to remove this item?'
        message: '<p>Every reference to this item will be cleaned.</p><p>Your game may not save properly until you fix that!</p>'
        buttons: {
          yes: {
            label: 'Remove',
            className: 'btn-danger',
            callback: ->
              self.removeItem(id)
          },
          no: {
            label: "I've changed my mind",
            className: 'btn-default'
          }
        }
      )

    $('form', @container).submit (e) ->
      $this = $(this)
      e.preventDefault()

      item = {
        id: "item-#{uuid.v4()}",
        name: $this.find(':input[name="name"]').val(),
        description: $this.find(':input[name="description"]').val(),
        image: $this.find(':input[name="image"]').val()
      }

      self.addItem(item)

  addItem: (item) ->
    @editor.adventure.items.push(item)
    @render()

  removeItem: (id) ->
    item_index = @_itemIndex(id)
    delete @editor.adventure.items[item_index] if item_index != -1
    @editor.adventure.items = @editor.adventure.items.compact()
    $('tr[data-item-id="' + id + '"]').remove()

  _itemIndex: (id) ->
    item_index = -1
    @editor.adventure.items.each (item, i) ->
      if item.id == id
        item_index = i
        false
      else
        true
    item_index



class Editor.Sidebar.Settings extends Editor.Sidebar.Base
  template: 'settings'

  context: ->
    {
      settings: @editor.adventure.settings,
      game_types: @editor.GAME_TYPES
    }

  afterRender: ->
    self = this
    $("input, select, textarea", @container).change ->
      $this = $(this)
      self.editor.adventure.settings[$this.attr('name')] = $this.val()

window.Editor = Editor