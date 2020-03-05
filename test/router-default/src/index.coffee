Yma = require 'yma'
window.app = Yma 'myApp'
.component require '../../../dist/index'
.component 'about', (app) ->
  controller: (scope) ->
