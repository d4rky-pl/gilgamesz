#= require graph

$ ->
  $('#forms').html JST['edit/adventure_form'](adventure: gon.adventure, game_types: gon.game_types)
