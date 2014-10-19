class Editor.Utils
  @find: (collection, id, key='id') ->
    id = @findIndex(collection, id, key)
    if id != -1
      collection[id]
    else
      null

  @findIndex: (collection, id, key='id') ->
    index = -1
    collection.each (element, i) ->
      if element[key] == id
        index = i
        false
      else
        true
    index