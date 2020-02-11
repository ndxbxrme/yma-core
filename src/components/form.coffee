module.exports = (app) ->
  count = 0
  controller: (scope, elem, props) ->
    if props.name
      if props.name
        myvar = {}

        app.$setScopeVar props.name, myvar, scope.$parent
        app.$setScopeVar props.name, myvar, scope
        myvar = app.$getScopeVar props.name, scope
        if props.submit
          submit = (event) ->
            scope.$event = event
            app.$eval props.submit, scope
            event.preventDefault = true
            false
          add.$addEventListener 'submit', submit
      myvar
