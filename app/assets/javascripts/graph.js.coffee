$(document).ready ->
  if $("#graph").length > 0
    graph = new $jit.ST(

      offsetX: $("#graph").width() / 2 - 100

    #the number of levels to show for a subtree
      levelsToShow: 100

    #id of viz container element
      injectInto: "graph"

    #set duration for the animation
      duration: 400

    #set animation transition type
      transition: $jit.Trans.Quart.easeInOut

    #set distance between node and its children
      levelDistance: 100

    #enable panning
      Navigation:
        enable: true
        panning: true


    #set node and edge styles
    #set overridable=true for styling individual
    #nodes or edges
      Node:
        height: 34
        autoWidth: true
        type: "rectangle"
        overridable: true
        color: '#fff'

      Edge:
        type: "bezier"
        overridable: true

      onBeforeCompute: (node) ->
        console.log "loading " + node.name
        return

      onAfterCompute: ->
        console.log "done"
        return


    #This method is called on DOM label creation.
    #Use this method to add event handlers and styles to
    #your node.
      onCreateLabel: (label, node) ->
        plus = "<span class='glyphicon glyphicon-plus'></span> New event"
        buttonClass = `node.data.persisted ? 'primary' : 'default'`
        label.id = node.id
        label.innerHTML = "<div class='btn btn-" + buttonClass + "'>" + (node.name || plus) + "</div>"
        label.onclick = ->
          if node.data.url
            window.location.assign(node.data.url)
          return

        #set label styles
        style = label.style
        style.cursor = "pointer"
        style.background = "white"
        return


    #This method is called right before plotting
    #a node. It's useful for changing an individual node
    #style properties before plotting it.
    #The data properties prefixed with a dollar
    #sign will override the global node style properties.
      onBeforePlotNode: (node) ->
        return


    #This method is called right before plotting
    #an edge. It's useful for changing an individual edge
    #style properties before plotting it.
    #Edge data proprties prefixed with a dollar sign will
    #override the Edge global style properties.
      onBeforePlotLine: (adj) ->
        if adj.nodeFrom.selected and adj.nodeTo.selected
          adj.data.$color = "#eed"
          adj.data.$lineWidth = 3
        else
          delete adj.data.$color

          delete adj.data.$lineWidth
        return
    )

    #load json data
    graph.loadJSON gon.adventure

    #compute node positions and layout
    graph.compute()

    #optional: make a translation of the tree
    graph.geom.translate new $jit.Complex(-200, 0), "current"

    #emulate a click on the root node.
    graph.onClick graph.root