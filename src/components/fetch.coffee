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
      if mockService = app.$getSerivce('mocks')
        if response = await mockService.$getResponse req
          return resolveData response
      resolveData = (response) ->
        try
          await fn response for fn in app.$postFetch
          if options.$postFetch
            await fn response for fn in options.$postFetch
        catch e
          return reject e
        resolve response
      req.open options.url, options.method, true
      req.onreadystatechange = ->
        resolveData @ if @.readyState is 4

      req.send options.data
