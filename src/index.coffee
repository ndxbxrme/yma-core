module.exports =
  go:         require './components/go'
  hide:       require './components/hide'
  "if":       require './components/if'
  press:      require './components/press'
  repeat:     require './components/repeat'
  controller: require './components/controller'
  router:     require './components/router'
  model:      require './components/model'
  autofocus:  require './components/autofocus'
  form:       require './components/form'
  required:   require './components/required'
  fetch:      require './components/fetch'
  mocks:      require './components/mocks'
  scene: (app) ->
    controller: (scope) ->
      console.log 'scene'
