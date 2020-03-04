Yma = require 'yma'
window.app = Yma 'myApp'
.component require '../../../dist/index'
.component 'app', (app) ->
  template: document.getElementById('app').innerText
  controller: (scope) ->
    scope.noThings = 6
    scope.date = new Date()
