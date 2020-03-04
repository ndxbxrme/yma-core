module.exports = (app) ->
  app.$appendStyles '.yma-router-parked {display:none}'
  callbacks = app.Callbacks()
  scenes = {}
  routerScope = null
  checkScenePath = (pathname, route) ->
    params = []
    reg = route.replace /:(\w+)/g, (all, param) ->
      params.push param
      '([^/]+)'
    regex = new RegExp '^' + reg + '$'
    data = {}
    if m = pathname.match regex
      for match, i in m
        continue if i is 0
        data[params[i - 1]] = match
      return data
    else
      return null
  parsePath = (pathname) ->
    defaultScene = null
    for name, scene of scenes
      defaultScene = scene if scene.default
      if data = checkScenePath pathname, scene.route
        return
          name: scene.scene
          data: data
    return
      name: defaultScene.scene
      data: {}
  go = (name, data)->
    routerScope.$scene =
      scene: name
      data: data
    routerScope.$update()
  controller: (scope, elem, props) ->
    routerScope = scope
    scope.$scene = null
    app.$once 'rendered', ->
      scope.$scene = parsePath window.location.pathname
      scope.$update()
  service: ->
    go: go
    $on: callbacks.$on
    parsePath: parsePath
    addScene: (scene) ->
      scenes[scene.scene] = scene
