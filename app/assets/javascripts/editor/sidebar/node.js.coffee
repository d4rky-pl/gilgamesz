class Editor.Sidebar.Node extends Editor.Sidebar.Base
  template: 'node/passage'
  current: null

  constructor: (@editor, @container) ->
    super
    @current = @editor.adventure.nodes[0]
    @serializers = new Editor.Sidebar.Node.Serializers(@editor)

  createNewNode: (type) ->
    obj = $.extend(true, {}, Editor.Sidebar.Node.Templates[type])
    obj.id = "#{obj.type}-#{uuid.v4()}"
    @editor.adventure.nodes.push(obj)
    setNode(obj.id)

  setNode: (id) ->
    @current_index = @_nodeIndex(id)
    @current = @editor.adventure.nodes[@current_index]
    @render()

  updateNodeFromForm: (obj) ->
    @editor.adventure.nodes[@current_index] = @serializers[@current.type](@current, obj)

  context: ->
    {
      node: @current
      items: @editor.adventure.items
    }

  beforeRender: ->
    @template = "node/#{@current.type}"

  afterRender: ->
    self = this
    @form = $('form', @container)

    $(':input', @container).change =>
      @updateNodeFromForm(@form.serializeJSON())

    $('.selectpicker', @container).selectpicker()

  _nodeIndex: (id) ->
    node_index = -1
    @editor.adventure.nodes.each (node, i) ->
      if node.id == id
        node_index = i
        false
      else
        true
    node_index


