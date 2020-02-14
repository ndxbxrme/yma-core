module.exports = (app) ->
  app.$preFetch = []
  app.$postFetch = []
  (options) ->
    new Promise (resolve, reject) ->
      try
        await fn options for fn in app.$preFetch
        if options.$preFetch
          await fn options for fn in options.$preFetch
      catch e
        return reject e
      options.method = options.method or 'GET'
      req = new XMLHttpRequest()
      if options.headers
        req.setRequestHeader key, value for key, value of options.headers
      req.setRequestHeader 'Content-Type', 'application/x-www-form-urlencode'
      req.onreadystatechange = ->
        if @.readyState is 4
          try
            await fn @ for fn in app.$postFetch
            if options.$postFetch
              await fn @ for fn in options.$postFetch
          catch e
            return reject e
          resolve @
