class Graph
  constructor: (@editor, @selector) ->
    @$element = $(@selector)
    @initGraph()
    @bindEvents()
    @selectionModeEnabled = false
    @selectionModeCb = (node_id) ->
    window._graph = this

  bindEvents: ->
    self = this

    $(window).on 'resize', ->
      self.rerender()

    @$element.on 'click', '.node', ->
      if self.selectionModeEnabled
        self.selectionModeCb.call(this, $(this).data('id'))
        self.selectionModeEnabled = false
      else
        self.editor.selectNode($(this).data('id'))
      return false

  selectionMode: (callback) ->
    @selectionModeEnabled = true
    @selectionModeCb = callback

  # methods for infovis graph initialization

  initGraph: ->
    @graphElement = new $jit.ForceDirected(
      injectInto: @$element.attr('id')
      Navigation:
        enable: true
        panning: "avoid nodes"
      Edge:
        type: 'arrow'
        overridable: true
        color: "#8f8f8f"
        lineWidth: 2
      Label:
        type: "HTML"
        size: 10
      iterations: 1
      levelDistance: 150

      onCreateLabel: (domElement, node) ->
        domElement.innerHTML = JST['editor/graph_node'](node: node)

      onPlaceLabel: (domElement, node) ->
        style = domElement.style
        left = parseInt(style.left)
        top = parseInt(style.top)
        w = domElement.offsetWidth
        style.left = (left - w / 2) + "px"
        style.top = (top - 25) + "px"
    )
    @graphElement.loadJSON @graphJSON()

  render: ->
    @graphElement.computeIncremental
      onComplete: $.proxy(@renderCallback, this)

  rerender: ->
    @$element.html('');
    @initGraph();
    @render();

  renderCallback: ->
    @graphElement.animate
      modes: ["linear"]
      transition: $jit.Trans.Elastic.easeOut
      duration: 0

  # methods for building graph JSON

  graphJSON: ->
    gon.adventure.nodes.map $.proxy(@translateNode, this)

  translateNode: (node) ->
    {
      id: node.id
      name: node.name
      data:
        type: node.type
      adjacencies: @actions(node)
    }

  actions: (node) ->
    if node.events
      Object.values(node.events).map((event) ->
        event.actions.map (action) ->
          {
            "nodeTo": action.node_id
            "data":
              "$direction": [node.id, action.node_id]
          }
      ).flatten()
    else if node.actions
      node.actions.map (action) ->
        {
          "nodeTo": action.node_id
          "data":
            "$direction": [node.id, action.node_id]
        }
    else
      []

window.Graph = Graph