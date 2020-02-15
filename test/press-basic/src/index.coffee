Yma = require 'yma'
window.app = Yma 'myApp'
.component require '../../../dist/index'
.component 'app', (app) ->
  controller: (scope) ->
    scope.testVar = 'bazaza'
