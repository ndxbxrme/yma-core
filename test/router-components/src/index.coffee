
window.app = require('yma') 'myapp'
window.app
.component require '../../../dist/index'
.component 'app', require './components/app/app'
.component 'menu', require './components/menu/menu'
.component 'home', require './components/home/home'
.component 'footer', require './components/footer/footer'
