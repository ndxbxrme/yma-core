module.exports = (app) ->
  pre: (scope, elem, props) ->
    ctrl = app.components[props.controller.toUpperCase()]
    ctrl.controller scope if ctrl
    null
