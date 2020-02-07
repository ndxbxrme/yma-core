styles = document.createElement 'style'
styles.innerText = '.yma-router-parked, .yma-hidden {display:none}'
document.querySelector 'head'
.append styles
module.exports =
  go: require './components/go'
  hide: require './components/hide'
  "if": require './components/if'
  press: require './components/press'
  repeat: require './components/repeat'
  controller: require './components/controller'
  router: require './components/router'
  model: require './components/model'
  autofocus: require './components/autofocus'
