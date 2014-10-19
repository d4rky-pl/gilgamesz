class Editor.Sidebar.Node.Serializers
  constructor: (@editor) ->

  passage: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node.actions = Object.values(form_data.actions) || []

    node

  add_item: (node, form_data) ->
    node.name = form_data.name
    node.item_id = form_data.item_id || null

    ['add_item', 'already_has_item'].each (event_name) ->
      node.events[event_name].description = form_data[event_name].description

      if form_data.events && form_data.events[event_name]
        node.events[event_name].actions = Object.values(form_data.events[event_name].actions)
      else
        node.events[event_name].actions = []

    node

  use_item: (node, form_data) ->
    node.name = form_data.name
    node.item_id = form_data.item_id || null
    node.remove_after = !!form_data.remove_after

    ['use_item', 'already_used_item', 'no_item'].each (event_name) ->
      node.events[event_name].description = form_data[event_name].description
      if form_data.events && form_data.events[event_name]
        node.events[event_name].actions = Object.values(form_data.events[event_name].actions)
      else
        node.events[event_name].actions = []

    node

  gameover: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node

  finish: (node, form_data) ->
    node.name = form_data.name
    node.description = form_data.description
    node
