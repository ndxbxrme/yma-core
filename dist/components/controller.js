// Generated by CoffeeScript 2.5.1
(function() {
  module.exports = function(app) {
    return {
      pre: function(scope, elem, props) {
        var ctrl;
        ctrl = app.components[props.controller.toUpperCase()];
        if (ctrl) {
          ctrl.controller(scope);
        }
        return null;
      }
    };
  };

}).call(this);

//# sourceMappingURL=controller.js.map
