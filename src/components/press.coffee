module.exports = (app) ->
  (scope, elem, props) ->
    if /\(/.test props.press
      listener = (event) ->
        scope.$event = event
        app.$eval props.press, scope
        delete scope.$event
    else
      listener = app.$eval props.press, scope
    if typeof(listener) is 'function'
      scope.$addEventListeners elem, ['mousedown', 'click'], listener
