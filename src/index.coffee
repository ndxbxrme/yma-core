styles = document.createElement 'style'
styles.innerText = '.yma-router-parked, .yma-hidden {display:none}'
document.querySelector 'head'
.append styles
module.exports =
  go: ->
    (scope, elem, props) ->
      scope.$use 'router'
      scene = scope.router.parsePath props.go
      listener = (event) ->
        scope.router.go scene.name, scene.data
      scope.$addEventListeners elem, 'mousedown', listener
  hide: (app) ->
    (scope, elem, props) ->
      if props.hide and app.$eval props.hide, scope
        app.$addClass elem, 'yma-hidden'
  "if": (app) ->
    pre: (scope, elem, props) ->
      console.log 'if', props['if']
      if props["if"] and app.$eval props["if"], scope
        console.log 1
        return [scope]
      else
        console.log 2
        return []
  press: (app) ->
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
  repeat: (app) ->
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
  controller: (app) ->
    pre: (scope, elem, props) ->
      ctrl = app.components[props.controller.toUpperCase()]
      ctrl.controller scope if ctrl
      null
  router: (app) ->
    callbacks = app.Callbacks()
    scenes = {}
    currentscene = null
    routerScope = null
    rendered = false
    bootstrapped = false
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
      for name, scene of scenes
        if data = checkScenePath pathname, scene.route
          return
            name: scene.name
            data: data
    go = (name, data, firstTime) ->
      if currentscene.name is name and JSON.stringify(currentscene.data) is JSON.stringify(data) and not firstTime
        return
      nextscene = scenes[name]
      return if not nextscene
      try
        await callbacks.$call 'sceneWillChange',
          from: currentscene
          to: nextscene
      catch e
        go e.redirect if e.redirect
        return
      if currentscene
        app.$removeClass currentscene.scene, ['yma-router-active', 'yma-transition-in']
        app.$addClass currentscene.scene, ['yma-router-parked', 'yma-transition-out']
        await app.$teardownChildren app.$makeId currentscene.scene
      await app.$teardownChildren app.$makeId nextscene.scene
      currentscene = nextscene
      currentscene.data = data or {}
      routerScope.data = data
      if nextscene.component
        nextscene.scene.innerHTML = '<' + nextscene.component + '>' + nextscene.html + '</' + nextscene.component + '>'
      else
        nextscene.scene.innerHTML = nextscene.html
      await app.$renderChildren nextscene.scene, routerScope
      app.$removeClass nextscene.scene, ['yma-router-parked', 'yma-transition-out']
      app.$addClass nextscene.scene, ['yma-router-active', 'yma-transition-in']
      routes = currentscene.route.replace /:(\w+)/g, (all, param) ->
        currentscene.data[param]?.toString() or all
      .split /\|/g
      route = ''
      for r in routes
        if r.length > route.length and not /:/.test r
          route = r
      window.history.pushState route, null, route if route isnt window.location.pathname
    controller: (scope, elem) ->
      routerScope = scope
      if currentscene
        routerScope.data = currentscene.data
      else
        scope.$on 'bootstrap', ->
          return if bootstrapped
          for scene in elem.querySelectorAll 'scene'
            props = app.$getProps scene
            props.scene = scene
            props.html = scene.innerHTML
            params = []
            if props.route
              if data = checkScenePath props.route, window.location.pathname
                props.data = data
                scope.data = data
                currentscene = props
            scenes[props.name] = props
            currentscene = props if (typeof(props.default) isnt 'undefined') and not currentscene
            currentscene = props if props.name is currentscene.name
            scene.removeAttribute 'route'
            app.$addClass scene, 'yma-router-parked'
          bootstrapped = true
          go currentscene.name, currentscene.data, true if rendered and bootstrapped
      firstTime = ->
        if not rendered
          rendered = true
          go currentscene.name, currentscene.data, true if rendered and bootstrapped
        app.$off 'rendered', firstTime
      app.$on 'rendered', firstTime
      routerScope.$on 'update', ->
        for name, scene of scenes
          scene.scene = elem.querySelector 'scene[name="' + scene.name + '"]'
          app.$removeClass scene.scene, 'yma-router-active'
          app.$addClass scene.scene, 'yma-router-parked'
        app.$removeClass currentscene.scene, 'yma-router-parked'
        app.$addClass currentscene.scene, 'yma-router-active'
    service: ->
      go: go
      $on: callbacks.$on
      parsePath: parsePath
  model: (app) ->
    (scope, elem, props) ->
      setValue = ->
        if elem.value isnt app.$eval props.model
          value = app.$getScopeVar props.model, scope
          elem.value = value if typeof(value) isnt 'undefined'
      setValue()
      updateModel = (event) ->
        scope[props.model] = elem.value
        app.$setScopeVar props.model, elem.value, scope
        scope.$update()
      scope.$addEventListeners elem, ['keyup', 'change', 'paste', 'mouseup'], updateModel
      scope.$on 'update', setValue
  autofocus: ->
    (scope, elem) ->
      elem.focus()
