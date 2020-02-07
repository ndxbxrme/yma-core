module.exports = (app) ->
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
