class Editor.Sidebar.Node extends Editor.Sidebar.Base
  template: 'node/passage'
  current: null

  constructor: (@editor, @container) ->
    super
    @current = @editor.root_node
    @serializers = new Editor.Sidebar.Node.Serializers(@editor)

  setNode: (id) ->
    @current_index = Editor.Utils.findIndex(@editor.adventure.nodes, id)
    @current = @editor.adventure.nodes[@current_index]
    @render()

  updateNodeFromForm: (obj) ->
    @editor.adventure.nodes[@current_index] = @serializers[@current.type](@current, obj)

  context: ->
    {
      node: @current
      items: @editor.adventure.items
      remove_button_class: ('disabled' unless @show_delete_button)
    }

  beforeRender: ->
    @template = "node/#{@current.type}"
    @show_delete_button = @editor.canNodeBeDeleted(@current)

  afterRender: ->
    self = this
    @form = $('form', @container)

    $('[data-action-box]').each ->
      (new Editor.Sidebar.Node.Actions($(this), self.editor, self.current)).render()

    $(':input', @container).change =>
      @updateNodeFromForm(@form.serializeJSON())

    $('[data-action="remove-node"]').click (e) ->
      e.preventDefault();
      self.editor.removeNode(self.current.id)

    $('.selectpicker', @container).selectpicker()
    $('textarea', @container).wysihtml5
      'toolbar':
        'font-styles': false
        'lists': false
        'size': 'sm'
