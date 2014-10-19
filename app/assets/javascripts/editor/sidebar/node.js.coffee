class Editor.Sidebar.Node extends Editor.Sidebar.Base
  template: 'node/passage'
  current: null

  constructor: (editor, container) ->
    super
    @current = @editor.adventure.nodes[0]

  createNewNode: (type) ->
    obj = $.extend(true, {}, Editor.Sidebar.Node.Templates[type])
    obj.id = "#{obj.type}-#{uuid.v4()}"
    @editor.adventure.nodes.push(obj)
    setNode(obj.id)

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

  afterRender: ->
    self = this
    $('form', @container).submit (e) ->
      e.preventDefault()
      self.current = Editor.Sidebar.Node.Serializers[self.current.type]($(this).serializeJSON())

  _nodeIndex: (id) ->
    node_index = -1
    @editor.adventure.nodes.each (node, i) ->
      if node.id == id
        node_index = i
        false
      else
        true
    node_index


