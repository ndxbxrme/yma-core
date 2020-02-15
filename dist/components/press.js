// Generated by CoffeeScript 2.5.1
(function() {
  module.exports = function(app) {
    return function(scope, elem, props) {
      var listener;
      if (/\(/.test(props.press)) {
        listener = function(event) {
          scope.$event = event;
          app.$eval(props.press, scope);
          return delete scope.$event;
        };
      } else {
        listener = app.$eval(props.press, scope);
      }
      if (typeof listener === 'function') {
        return scope.$addEventListeners(elem, ['click'], listener);
      }
    };
  };

}).call(this);

//# sourceMappingURL=press.js.map
