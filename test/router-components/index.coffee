
window.app = require('yma') 'myapp'
.component require '../../../dist/index'
.component 'app', require './components/app/app.coffee'
.component 'menu', require './components/menu/menu.coffee'
.component 'home', require './components/home/home.coffee'
.component 'footer', require './components/footer/footer.coffee'
.render()
