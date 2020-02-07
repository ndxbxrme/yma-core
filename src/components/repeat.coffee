module.exports = (app) ->
  hashes = []
  pre: (scope, elem, props) ->
    itemName = 'item'
    repeat = props.repeat
    repeat = repeat.replace /\sas\s([\w_]+)$/, (all, name) ->
      itemName = name
      ''
    arr = app.$eval(repeat, scope)
    if arr
      results = arr.map (item, i) ->
        hash = app.$hash JSON.stringify item
        hashIndex = hashes.indexOf hash
        newscope = app.Scope scope
        newscope[itemName] = item
        newscope.$index = i
        newscope.$first = i is 0
        newscope.$last = i is arr.length - 1
        newscope.$fresh = hashIndex is -1
        newscope.$moveUp = hashIndex > i
        newscope.$moveDown = hashIndex isnt -1 and hashIndex < i
        newscope.$lastIndex = hashIndex
        #newscope.$dataid = app.$hash JSON.stringify app.$hashObject newscope
        newscope
      if scope.$phase is 'render'
        hashes = results.map (scope) ->
          app.$hash JSON.stringify scope[itemName]
      return results
    else
      return []
