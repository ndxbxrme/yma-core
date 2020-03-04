// Generated by CoffeeScript 2.5.1
(function() {
  module.exports = function(app) {
    var callbacks, checkScenePath, go, parsePath, routerScope, scenes;
    app.$appendStyles('.yma-router-parked {display:none}');
    callbacks = app.Callbacks();
    scenes = {};
    routerScope = null;
    checkScenePath = function(pathname, route) {
      var data, i, j, len, m, match, params, reg, regex;
      params = [];
      reg = route.replace(/:(\w+)/g, function(all, param) {
        params.push(param);
        return '([^/]+)';
      });
      regex = new RegExp('^' + reg + '$');
      data = {};
      if (m = pathname.match(regex)) {
        for (i = j = 0, len = m.length; j < len; i = ++j) {
          match = m[i];
          if (i === 0) {
            continue;
          }
          data[params[i - 1]] = match;
        }
        return data;
      } else {
        return null;
      }
    };
    parsePath = function(pathname) {
      var data, name, scene;
      console.log('pathname', pathname);
      for (name in scenes) {
        scene = scenes[name];
        console.log('checking', name, scene);
        if (data = checkScenePath(pathname, scene.route)) {
          return {
            name: scene.scene,
            data: data
          };
        }
      }
    };
    go = function(name, data) {
      routerScope.$scene = {
        scene: name,
        data: data
      };
      return routerScope.$update();
    };
    return {
      controller: function(scope, elem, props) {
        routerScope = scope;
        scope.$scene = null;
        return app.$once('rendered', function() {
          scope.$scene = parsePath(window.location.pathname);
          return scope.$update();
        });
      },
      service: function() {
        return {
          go: go,
          $on: callbacks.$on,
          parsePath: parsePath,
          addScene: function(scene) {
            return scenes[scene.scene] = scene;
          }
        };
      }
    };
  };

}).call(this);

//# sourceMappingURL=router.js.map
