{getFormElement, addFormError, removeFormError} = require './common'


module.exports = (app) ->
  pre: (scope, elem, props) ->
    formElement = getFormElement elem
    formElement[props.name] = formElement[props.name] or {}
    formElement[props.name].$validators = formElement[props.name].$validators or []
    doValidate = ->
      if app.$eval props.required
        if formElement[props.name].$value and formElement[props.name].$value isnt 0
          removeFormError 'required', elem, props
        else
          addFormError 'required', elem, props
    formElement[props.name].$validators.push doValidate
    doValidate()
