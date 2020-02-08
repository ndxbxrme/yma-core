module.exports = (app) ->
  app.$appendStyles '.yma-hidden {display:none}'
  (scope, elem, props) ->
    if props.hide and app.$eval props.hide, scope
      app.$addClass elem, 'yma-hidden'
