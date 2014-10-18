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

  context: ->
    {
      items: @editor.adventure.items,
      available_images: gon.available_images
    }

  afterRender: ->
    @bindRemoveButtons()


  bindRemoveButtons: ->
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

  addItem: (item) ->
    @editor.adventure.items.push(item)

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