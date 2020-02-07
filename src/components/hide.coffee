module.exports = (app) ->
  (scope, elem, props) ->
    if props.hide and app.$eval props.hide, scope
      app.$addClass elem, 'yma-hidden'
