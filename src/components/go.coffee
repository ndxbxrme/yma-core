module.exports = ->
  (scope, elem, props) ->
    scope.$use 'router'
    scene = scope.router.parsePath props.go
    listener = (event) ->
      scope.router.go scene.name, scene.data
    scope.$addEventListeners elem, 'mousedown', listener
