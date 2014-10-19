class Editor.Sidebar.Inventory extends Editor.Sidebar.Base
  template: 'inventory'

  context: ->
    {
    items: @editor.adventure.items,
    available_images: gon.available_images
    }

  afterRender: ->
    self = this
    $('.selectpicker', @container).selectpicker()
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
    self = this
    bootbox.confirm "<p>Are you sure you want to remove this item?</p><p>This action cannot be undone. All references to this item will be removed from your game.</p>", (result) ->
      if result
        item_index = Editor.Utils.findIndex(self.editor.adventure.items, id)
        self.removeItemReferences(id)
        if item_index != -1
          delete self.editor.adventure.items[item_index]
          self.editor.adventure.items = self.editor.adventure.items.compact()
          $('tr[data-item-id="' + id + '"]', self.container).remove()

  removeItemReferences: (id) ->
    @editor.adventure.nodes.each (node) ->
      node.item_id = null if(node.item_id == id)

