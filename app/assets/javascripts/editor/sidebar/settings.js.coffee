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