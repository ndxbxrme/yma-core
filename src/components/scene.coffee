module.exports = (app) ->
  pre: (scope, elem, props) ->
    scope.$use 'router'
    scope.router.addScene props
    if props.scene isnt scope.scene?.name
      return []
    null
