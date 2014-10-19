class Editor.Sidebar.Node.Actions
  constructor: (@container, @editor, @node) ->
    @namespace = @container.data('action-box-namespace')

  createAction: (node) ->
    @actions().push(
      id: "action-#{uuid.v4()}"
      node_id: node.id
      description: "<p>Your text goes here</p>"
    )
    @editor.graph.rerender()
    @render()

  removeAction: (id) ->
    index = Editor.Utils.findIndex(@actions(), id)
    action = @actions()[index]
    return unless action
    if @canActionBeDeleted(action)
      if @namespace
        delete @node.events[@namespace].actions[index]
        @node.events[@namespace].actions = @node.events[@namespace].actions.compact()

      else
        delete @node.actions[index]
        @node.actions = @node.actions.compact()

      @editor.rerender()
      @render()
    else
      bootbox.alert("<p>Action can only be removed if the node it connects to has any other connections.</p><p>Please remove the node this action is referring to first.</p>")

  canActionBeDeleted: (action) ->
    @editor.nodeParentsCount(action.node_id) > 1 || action.node_id == @editor.root_node

  modal: ->
    self = this
    bootbox.dialog(
      title: 'Create new action'
      message: JST['editor/action_modal']()
    ).on("shown.bs.modal", (e) ->
      $this = $(this)

      $('button[data-new-node]').click ->
        type = $(this).data('new-node')

        node = self.editor.createNode(type)
        self.createAction(node)
        $this.modal('hide')

      $('button[existing-node').click ->
        self.editor.graph.selectionMode (node_id) ->
          node = self.editor.getNode(node_id)
          self.createAction(node)
          $this.modal('hide')
    )

  render: ->
    self = this
    @container.html(JST['editor/actions'](
      actions: @actions()
      namespace: @input_namespace()
      node_name: $.proxy(this, 'node_name')
    ))

    $('[data-action="remove"]').click (e) ->
      e.preventDefault()
      $this = $(this)
      action_id = $(this).data('action-id')
      self.removeAction(action_id)

    $('[data-action="set-node"]').click (e) ->
      e.preventDefault()
      self.editor.sidebar.setNode($(this).data('action-node-id'))

    $('button', @container).click (e) ->
      e.preventDefault()
      self.modal()

  actions: ->
    if @namespace
      @node.events[@namespace].actions
    else
      @node.actions

  input_namespace: ->
    if @namespace
      "events[#{@namespace}][actions]"
    else
      "actions"

  node_name: (node_id) ->
    node = @editor.getNode(node_id)
    "#{node.name} (#{Editor.NODE_TYPES[node.type]})"
