$(document).ready ->
  $("[rel='tooltip']").tooltip()
  $(this).find(".caption").fadeOut 250
  $(".thumbnail").hover (->
    $(this).find(".caption").fadeIn 250
  ), ->
    $(this).find(".caption").fadeOut 250

  $("#table-all-games th a, #table-all-games .pagination a").on "click", ->
    $.getScript @href
    false
