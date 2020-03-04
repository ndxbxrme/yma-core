module.exports = (app) ->
  console.log 'scene'
  pre: (scope, elem, props) ->
    console.log 'scene pre'
    scope.$use 'router'
    scope.router.addScene props
    console.log props.scene, scope.$scene?.name
    if props.scene isnt scope.$scene?.name
      console.log 'returning empty handed'
      return []
    null
