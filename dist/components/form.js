// Generated by CoffeeScript 2.5.1
(function() {
  module.exports = function(app) {
    var count;
    count = 0;
    return {
      controller: function(scope, elem, props) {
        var myvar, submit;
        if (props.name) {
          if (props.name) {
            myvar = {};
            app.$setScopeVar(props.name, myvar, scope.$parent);
            app.$setScopeVar(props.name, myvar, scope);
            myvar = app.$getScopeVar(props.name, scope);
            if (props.submit) {
              submit = function(event) {
                scope.$event = event;
                app.$eval(props.submit, scope);
                event.preventDefault = true;
                return false;
              };
              add.$addEventListener('submit', submit);
            }
          }
          return myvar;
        }
      }
    };
  };

}).call(this);

//# sourceMappingURL=form.js.map
