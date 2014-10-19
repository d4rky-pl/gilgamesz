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