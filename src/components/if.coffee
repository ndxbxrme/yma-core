module.exports = (app) ->
  pre: (scope, elem, props) ->
    if props["if"] and app.$eval props["if"], scope
      return [scope]
    else
      return []
