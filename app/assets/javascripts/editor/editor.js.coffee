class Editor
  @GAME_TYPES: ['fantasy','scifi','detective']
  @NODE_TYPES: {
    passage: 'Passage',
    add_item: 'Add Item',
    use_item: 'Use Item',
    gameover: 'Game Over',
    finish: 'Finish'
  }

  constructor: (container, adventure) ->
    @container = $(container)
    @container.html(JST['editor/template']())

    @adventure = adventure
    @root_node = @adventure.nodes[0]

    @sidebar = new Editor.Sidebar(this, '#sidebar')
    @graph   = new Graph(this, '#graph')

    @createParentsMap()
    @bindSaveButton()

    window._editor = this

  bindSaveButton: ->
    self = this
    $('[data-editor-save]', @container).click ->
      bootbox.dialog(
        title: 'You are almost there'
        message: """
          <p>If you ever want to go back to editing your story, bookmark the link below:</p>
          <p><input type="text" class="form-control" value="#{gon.edit_url}"></p>

        """
        buttons: {
          publish: {
            label: 'OK, save and publish!'
            className: 'btn-primary'
            callback: ->
              self.submit()
              false
          },
          cancel: {
            label: "I'm not done yet"
            className: 'btn-default'
          }
        }
      )

  submit: ->
    if !@validItems()
      bootbox.alert("You cannot have Use Item nor Add Item nodes without actual item!")
    else if !@validActions()
      bootbox.alert("You cannot have a Passage, Add Item or Use Item node without any actions!")
    else
      $('#editor-adventure-json').val(JSON.stringify(@adventure))
      $('#editor-adventure-form').submit()

  validItems: ->
    valid = true
    @adventure.nodes.each (node) ->
      valid = false unless node.item_id? && @itemExists(node.item_id)

  validActions: ->
    valid = true
    @adventure.nodes.each (node) ->
      if node.type == 'add_item' || node.type == 'use_item'
        Object.values node.events, (event) ->
          valid = false unless event? && event.actions? && event.actions.length > 0

      else if node.type == 'passage'
        valid = false unless node.actions? && node.actions.length > 0
    valid

  itemExists: (item_id) ->
    exists = false
    @adventure.items.each (item) ->
      exists = true if item.id == item_id
    exists

  render: ->
    @sidebar.render()
    @graph.render()

  rerender: ->
    @sidebar.render()
    @graph.rerender()

  # NODES

  selectNode: (id) ->
    @sidebar.tabs.node.setNode(id)

  getNode: (id) ->
    Editor.Utils.find(@adventure.nodes, id)

  createNode: (type, parent, data={}) ->
    obj = $.extend(true, {}, Editor.Sidebar.Node.Templates[type], data)
    obj.id = "#{obj.type}-#{uuid.v4()}"

    @adventure.nodes.push(obj)
    @parents_map[obj.id] = [parent]

    obj

  removeNode: (id) ->
    self = this
    node = @getNode(id)

    if @canNodeBeDeleted(node)
      @removeLinksToNode(node)
      index = Editor.Utils.findIndex(@adventure.nodes, node.id)
      delete @adventure.nodes[index]
      @adventure.nodes = @adventure.nodes.compact()
      @selectNode(@root_node.id)
      @graph.rerender()

    else
      bootbox.alert("<p>Node cannot be removed when it still has actions.</p><p>Please remove actions first.</p>")

  canNodeBeDeleted: (node) ->
    return false if node.id == @root_node.id

    action_count = 0
    if node.events
      Object.values(node.events, (event) ->
        action_count += event.actions.length
      )

    else if node.actions
      action_count = node.actions.length

    action_count == 0

  removeLinksToNode: (node) ->
    self = this
    @parents_map[node.id].each (node_id) ->
      parent_node = self.getNode(node_id)

      if parent_node.events
        Object.keys(parent_node.events, (event_name) ->
          index = Editor.Utils.findIndex(parent_node.events[event_name].actions, node.id, 'node_id')
          if index?
            delete parent_node.events[event_name].actions[index]
            parent_node.events[event_name].actions = parent_node.events[event_name].actions.compact()
        )

      else if parent_node.actions
        index = Editor.Utils.findIndex(parent_node.actions, node.id, 'node_id')
        if index?
          delete parent_node.actions[index]
          parent_node.actions = parent_node.actions.compact()
    delete @parents_map[node.id]



  # Node ParentsMap

  createParentsMap: ->
    parents_map = {}

    @adventure.nodes.each (node) ->
      parents_map[node.id] = [] unless parents_map[node.id]

      if node.actions
        node.actions.each (action) ->
          parents_map[action.node_id] = [] unless parents_map[action.node_id]
          parents_map[action.node_id].push(node.id)

      if node.events
        Object.values(node.events, (event) ->
          event.actions.each (action) ->
            parents_map[action.node_id] = [] unless parents_map[action.node_id]
            parents_map[action.node_id].push(node.id)
        )

    Object.keys(parents_map, (node_id) ->
      parents_map[node_id] = parents_map[node_id].unique()
    )

    @parents_map = parents_map

  nodeParentsCount: (node_id) ->
    @parents_map[node_id].length

window.Editor = Editor