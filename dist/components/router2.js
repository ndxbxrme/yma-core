// Generated by CoffeeScript 2.5.1
(function() {
  module.exports = function(app) {
    var bootstrapped, callbacks, checkScenePath, currentscene, go, parsePath, rendered, routerScope, scenes;
    app.$appendStyles('.yma-router-parked {display:none}');
    callbacks = app.Callbacks();
    scenes = {};
    currentscene = null;
    routerScope = null;
    rendered = false;
    bootstrapped = false;
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
      for (name in scenes) {
        scene = scenes[name];
        if (data = checkScenePath(pathname, scene.route)) {
          return {
            name: scene.name,
            data: data
          };
        }
      }
    };
    go = async function(name, data, firstTime) {
      var e, j, len, nextscene, r, route, routes;
      console.log('go to scene', name);
      if (currentscene.name === name && JSON.stringify(currentscene.data) === JSON.stringify(data) && !firstTime) {
        return;
      }
      nextscene = scenes[name];
      if (!nextscene) {
        return;
      }
      try {
        await callbacks.$call('sceneWillChange', {
          from: currentscene,
          to: nextscene
        });
      } catch (error) {
        e = error;
        if (e.redirect) {
          go(e.redirect);
        }
        return;
      }
      if (currentscene) {
        app.$removeClass(currentscene.scene, ['yma-router-active', 'yma-transition-in']);
        app.$addClass(currentscene.scene, ['yma-router-parked', 'yma-transition-out']);
        await app.$teardownChildren(app.$makeId(currentscene.scene));
      }
      await app.$teardownChildren(app.$makeId(nextscene.scene));
      currentscene.scene.innerHTML = '';
      currentscene = nextscene;
      currentscene.data = data || {};
      routerScope.data = data;
      if (nextscene.component) {
        nextscene.scene.innerHTML = '<' + nextscene.component + '>' + nextscene.html + '</' + nextscene.component + '>';
      } else {
        nextscene.scene.innerHTML = nextscene.html;
      }
      await app.$renderChildren(nextscene.scene, routerScope);
      app.$removeClass(nextscene.scene, ['yma-router-parked', 'yma-transition-out']);
      app.$addClass(nextscene.scene, ['yma-router-active', 'yma-transition-in']);
      routes = currentscene.route.replace(/:(\w+)/g, function(all, param) {
        var ref;
        return ((ref = currentscene.data[param]) != null ? ref.toString() : void 0) || all;
      }).split(/\|/g);
      route = '';
      for (j = 0, len = routes.length; j < len; j++) {
        r = routes[j];
        if (r.length > route.length && !/:/.test(r)) {
          route = r;
        }
      }
      if (route !== window.location.pathname) {
        window.history.pushState(route, null, route);
      }
      return app.$update('router');
    };
    return {
      controller: function(scope, elem) {
        var firstTime;
        routerScope = scope;
        if (currentscene) {
          routerScope.data = currentscene.data;
        } else {
          scope.$on('bootstrap', function() {
            var data, j, len, params, props, ref, scene;
            if (bootstrapped) {
              return;
            }
            ref = elem.querySelectorAll('scene');
            for (j = 0, len = ref.length; j < len; j++) {
              scene = ref[j];
              props = app.$getProps(scene);
              props.scene = scene;
              props.html = scene.innerHTML;
              params = [];
              if (props.route) {
                if (data = checkScenePath(props.route, window.location.pathname)) {
                  props.data = data;
                  scope.data = data;
                  currentscene = props;
                }
              }
              scenes[props.name] = props;
              if ((typeof props.default !== 'undefined') && !currentscene) {
                currentscene = props;
              }
              if (props.name === currentscene.name) {
                currentscene = props;
              }
              scene.removeAttribute('route');
              app.$addClass(scene, 'yma-router-parked');
              console.log('hiding scenes');
            }
            bootstrapped = true;
            if (rendered && bootstrapped) {
              return go(currentscene.name, currentscene.data, true);
            }
          });
        }
        firstTime = function() {
          if (!rendered) {
            rendered = true;
            if (rendered && bootstrapped) {
              go(currentscene.name, currentscene.data, true);
            }
          }
          return app.$off('rendered', firstTime);
        };
        app.$on('rendered', firstTime);
        return routerScope.$on('update', function() {
          var name, scene;
          for (name in scenes) {
            scene = scenes[name];
            scene.scene = elem.querySelector('scene[name="' + scene.name + '"]');
            app.$removeClass(scene.scene, 'yma-router-active');
            app.$addClass(scene.scene, 'yma-router-parked');
          }
          app.$removeClass(currentscene.scene, 'yma-router-parked');
          return app.$addClass(currentscene.scene, 'yma-router-active');
        });
      },
      service: function() {
        return {
          go: go,
          $on: callbacks.$on,
          parsePath: parsePath,
          name: function() {
            return currentscene.name;
          },
          data: function() {
            return currentscene.data;
          }
        };
      }
    };
  };

}).call(this);

//# sourceMappingURL=router2.js.map
