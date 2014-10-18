class Graph
  constructor: (@selector) ->
    @$element = $(@selector)
    @json = gon.adventure
    @startId = @json.nodes.first().id
    @initGraph()
    @bindEvents()

  bindEvents: ->
    @$element.on 'click', '.node', ->
      alert($(this).data('id'))
      return false

  # methods for infovis graph initialization
  initGraph: ->
    @graphElement = new $jit.ForceDirected(
      injectInto: @$element.attr('id')
      Navigation:
        enable: true
        panning: "avoid nodes"
        zooming: 10
      Node:
        overridable: false
      Edge:
        type: 'line'
        overridable: true
        color: "#8f8f8f"
        lineWidth: 2
      Label:
        type: "HTML"
        size: 10
      iterations: 200
      levelDistance: 150

      onCreateLabel: (domElement, node) ->
        domElement.innerHTML = JST['edit/graph_node'](node: node)

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

  renderCallback: ->
    @graphElement.animate
      modes: ["linear"]
      transition: $jit.Trans.Elastic.easeOut
      duration: 2500

  # methods for building graph JSON

  graphJSON: ->
    @json.nodes.map $.proxy(@translateNode, this)

  translateNode: (node) ->
    {
      id: node.id
      name: node.description || node.type
      data:
        type: node.type
      adjacencies: @actions(node)
    }

  actions: (node) ->
    if node.events
      Object.values(node.events).map((event) ->
        event.actions.map (action) ->
          action.node_id
      ).flatten()
    else if node.actions
      node.actions.map (action) ->
        action.node_id
    else
      []

window.Graph = Graph