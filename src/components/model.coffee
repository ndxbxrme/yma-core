
module.exports = (app) ->
  {getFormElement} = require('./common') app
  (scope, elem, props) ->
    formElement = getFormElement elem
    setValue = ->
      if elem.value isnt app.$eval props.model
        value = app.$getScopeVar props.model, scope
        elem.value = value if typeof(value) isnt 'undefined'
        if formElement
          formElement[props.name] = formElement[props.name] or {}
          formElement[props.name].$value = elem.value if typeof(value) isnt 'undefined'
          if formElement[props.name].$validators
            for validator in formElement[props.name].$validators
              await validator elem.value
    setValue()
    updateModel = (event) ->
      if formElement?[props.name].$validators
        for validator in formElement[props.name].$validators
          await validator elem.value
      formElement?[props.name].$value = elem.value if typeof(value) isnt 'undefined'
      updateData = {};
      updateData[props.model] = elem.value
      scope.$update(updateData)
    scope.$addEventListeners elem, ['keyup', 'change', 'paste'], updateModel
    scope.$on 'update', setValue
