class Editor.Sidebar.Node.Serializers
  constructor: (@editor) ->

  passage: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node

  add_item: (node, form_data) ->
    node.name = form_data.name
    node.item_id = form_data.node_id || null

    ['add_item', 'already_have_item'].each (event_name) ->
      node.events[event_name].description          = form_data[event_name].description

    node

  use_item: (node, form_data) ->
    node.name = form_data.name
    node.item_id = form_data.node_id || null

    ['use_item', 'already_used_item', 'no_item'].each (event_name) ->
      node.events[event_name].description          = form_data[event_name].description
    node

  gameover: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node

  finish: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node
