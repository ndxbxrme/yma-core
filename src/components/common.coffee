module.exports = (app) ->
  getFormElement = (elem) ->
    node = elem
    while node.parentNode and node.tagName isnt 'FORM'
      node = node.parentNode
    if node and node.tagName is 'FORM'
      formElement = app.$getElement(node).data
      if typeof(formElement) is 'undefined'
        formElement[props.name] = {}
        formElement = formElement[props.name]
    formElement
  getFormElement: getFormElement
  addFormError: (error, elem, props) ->
    formElement = getFormElement elem
    formElement.$errors = formElement.$errors or {}
    formElement.$errors[error] = formElement.$errors[error] or {}
    formElement.$errors[error][props.name] = true
    formElement[props.name] = formElement[props.name] or {}
    formElement[props.name].$errors = formElement[props.name].$errors or {}
    formElement[props.name].$errors[error] = true
  removeFormError: (error, elem, props) ->
    formElement = getFormElement elem
    delete formElement[props.name].$errors?[error]
    delete formElement[props.name].$errors if not Object.keys(formElement[props.name].$errors?).length
    delete formElement.$errors?[error]?[props.name]
    delete formElement.$errors?[error] if not Object.keys(formElement.$errors?[error]?).length
    delete formElement.$errors if not Object.keys(formElement.$errors?).length
