$(document).ready ->

  $("#recent .pagination a").on "click", ->
    $.getScript @href
    false

  $(".adventure .counter a").on "click", ->
    $this = $(this)
    $.post $this.attr("href"), adventure_id: $this.parent().attr("id").split("-counter-")[1]
    false
