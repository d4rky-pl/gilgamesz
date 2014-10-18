$(document).ready ->
  if $("#graph").length > 0
    graphElement = new $jit.ForceDirected(

      #id of the visualization container
      injectInto: "graph"

    #Enable zooming and panning
    #by scrolling and DnD
      Navigation:
        enable: true

      #Enable panning events only if we're dragging the empty
      #canvas (and not a node).
        panning: "avoid nodes"
        zooming: 10 #zoom speed. higher is more sensible


    # Change node and edge styles such as
    # color and width.
    # These properties are also set per node
    # with dollar prefixed data-properties in the
    # JSON structure.
      Node:
        overridable: true

      Edge:
        overridable: true
        color: "#23A4FF"
        lineWidth: 0.4


    #Native canvas text styling
      Label:
        type: "Native" #Native or HTML
        size: 10
        style: "bold"


    #Add Tips
      Tips:
        enable: true
        onShow: (tip, node) ->

          #count connections
          count = 0
          node.eachAdjacency ->
            count++
            return


          #display node info in tooltip
          tip.innerHTML = "<div class=\"tip-title\">" + node.name + "</div>" + "<div class=\"tip-text\"><b>connections:</b> " + count + "</div>"
          return


    # Add node events
      Events:
        enable: true
        type: "Native"

      #Change cursor style when hovering a node
        onMouseEnter: ->
          graphElement.canvas.getElement().style.cursor = "move"
          return

        onMouseLeave: ->
          graphElement.canvas.getElement().style.cursor = ""
          return


      #Update node positions when dragged
        onDragMove: (node, eventInfo, e) ->
          pos = eventInfo.getPos()
          node.pos.setc pos.x, pos.y
          graphElement.plot()
          return


      #Implement the same handler for touchscreens
        onTouchMove: (node, eventInfo, e) ->
          $jit.util.event.stop e #stop default touchmove event
          @onDragMove node, eventInfo, e
          return


      #Add also a click handler to nodes
        onClick: (node) ->
          return  unless node

          # Build the right column relations list.
          # This is done by traversing the clicked node connections.
          html = "<h4>" + node.name + "</h4><b> connections:</b><ul><li>"
          list = []
          node.eachAdjacency (adj) ->
            list.push adj.nodeTo.name
            return


          #append connections information
          $jit.id("inner-details").innerHTML = html + list.join("</li><li>") + "</li></ul>"
          return


    #Number of iterations for the FD algorithm
      iterations: 200

    #Edge length
      levelDistance: 80

    # Add text to the labels. This method is only triggered
    # on label creation and only for DOM labels (not native canvas ones).
      onCreateLabel: (domElement, node) ->
        domElement.innerHTML = node.name
        style = domElement.style
        style.fontSize = "0.8em"
        style.color = "#ddd"
        return


    # Change node styles when DOM labels are placed
    # or moved.
      onPlaceLabel: (domElement, node) ->
        style = domElement.style
        left = parseInt(style.left)
        top = parseInt(style.top)
        w = domElement.offsetWidth
        style.left = (left - w / 2) + "px"
        style.top = (top + 10) + "px"
        style.display = ""
        return
    )

    # load JSON data.
    graphElement.loadJSON new Graph(gon.adventure).nodes()

    # compute positions incrementally and animate.
    graphElement.computeIncremental
      iter: 40
      property: "end"
      onStep: (perc) ->
        console.log perc + "% loaded..."
        return

      onComplete: ->
        console.log "done"
        graphElement.animate
          modes: ["linear"]
          transition: $jit.Trans.Elastic.easeOut
          duration: 2500

        return

class Graph
  constructor: (@json) ->

  nodes: ->
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