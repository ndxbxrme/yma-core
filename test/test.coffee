localServer = require 'local-web-server'
puppeteer = require 'puppeteer'
global.navigator =
  userAgent: 'summat'
browser = null
page = null
ws = null
makeServer = (path) ->
  ws = localServer.create
    port: 23232
    directory: path
    spa: 'index.html'
gotoPage = (path, puppeteerOptions) ->
  browser = await puppeteer.launch puppeteerOptions
  page = await browser.newPage()
  await page.goto 'http://localhost:23232/' + (path or '')
closePage = ->
  await browser.close()
  ws.server.close()
waitForRendered = ->
  await page.evaluate () ->
    new Promise (resolve) ->
      window.app.$once 'rendered', ->
        resolve()
      window.app.render()
sleep = (time) ->
  new Promise (resolve) ->
    setTimeout resolve, time

exports.ymaCoreTest =
  "Should autofocus first input": (test) ->
    makeServer 'test/autofocus'
    await gotoPage ''
    await waitForRendered()
    test.ok await page.evaluate () -> document.querySelectorAll('input')[0] is document.activeElement
    test.ok await page.evaluate () -> document.querySelectorAll('input')[1] isnt document.activeElement
    await closePage()
    test.done()
  "Should display home scene": (test) ->
    makeServer 'test/router-basic'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('app').innerText
    test.equals str, 'home'
    await closePage()
    test.done()
  "Should display about scene": (test) ->
    makeServer 'test/router-basic'
    await gotoPage 'about'
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('app').innerText
    test.equals str, 'about'
    await closePage()
    test.done()
  "Should display users scene": (test) ->
    makeServer 'test/router-basic'
    await gotoPage 'users'
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('app').innerText
    test.equals str, 'users'
    await closePage()
    test.done()
  "Should display default scene": (test) ->
    makeServer 'test/router-default'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('app').innerText
    test.equals str, 'about'
    await closePage()
    test.done()
  "Should display router component": (test) ->
    makeServer 'test/router-components'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('router').innerText
    test.equals str, 'home'
    await closePage()
    test.done()
  "Should display router about component": (test) ->
    makeServer 'test/router-components'
    await gotoPage 'about'
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('router').innerText
    test.equals str, 'about'
    await closePage()
    test.done()
  "Should display home scene (update)": (test) ->
    makeServer 'test/router-update'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () -> document.querySelector('router').innerText
    test.equals str, 'home'
    await closePage()
    test.done()
  "Should display about scene (update)": (test) ->
    makeServer 'test/router-update'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          resolve document.querySelector('router').innerText
        document.querySelector('#goAbout').click()
    test.equals str, 'about'
    await closePage()
    test.done()
  "Should display about scene then go home (update)": (test) ->
    makeServer 'test/router-update'
    await gotoPage ''
    await waitForRendered()
    str = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          window.app.$once 'updated', ->
            resolve document.querySelector('router').innerText
          document.querySelector('#goHome').click()
        document.querySelector('#goAbout').click()
    test.equals str, 'home'
    await closePage()
    test.done()
  "Should press a button and update scope variable": (test) ->
    makeServer 'test/press-basic'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', () ->
          resolve document.querySelector('h1').innerHTML
        document.querySelector('a').click()
    test.equals val, 'boom'
    await closePage()
    test.done()
  "Should do a basic repeater test": (test) ->
    makeServer 'test/repeater-basic'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () -> document.querySelector('app').innerHTML
    test.equals val, '<h1>0 BARRY</h1><h1>1 BUDDY</h1><h1>2 MAGGIE</h1><h1>3 TEDDY</h1>'
    await closePage()
    test.done()
  "Should do a large repeater test": (test) ->
    makeServer 'test/repeater-large'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () -> document.querySelectorAll('h1').length
    test.equals val, 10000
    await closePage()
    test.done()
  "Should test repeater updating": (test) ->
    makeServer 'test/repeater-update'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () -> document.querySelectorAll('h2').length
    test.equals val, 6
    await closePage()
    test.done()
  "Should test repeater updating - add one": (test) ->
    makeServer 'test/repeater-update'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          resolve document.querySelectorAll('h2').length
        document.getElementById('more').click()
    test.equals val, 7
    await closePage()
    test.done()
  "Should test repeater updating - minus one": (test) ->
    makeServer 'test/repeater-update'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          resolve document.querySelectorAll('h2').length
        document.getElementById('less').click()
    test.equals val, 5
    await closePage()
    test.done()

  "Should test component repeater updating": (test) ->
    makeServer 'test/repeater-update-component'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () -> document.querySelectorAll('h2').length
    test.equals val, 6
    await closePage()
    test.done()
  "Should test component repeater updating - add one": (test) ->
    makeServer 'test/repeater-update-component'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          resolve document.querySelectorAll('h2').length
        document.getElementById('more').click()
    test.equals val, 7
    await closePage()
    test.done()
  "Should test component repeater updating - minus one": (test) ->
    makeServer 'test/repeater-update-component'
    await gotoPage ''
    await waitForRendered()
    val = await page.evaluate () ->
      new Promise (resolve) ->
        window.app.$once 'updated', ->
          resolve document.querySelectorAll('h2').length
        document.getElementById('less').click()
    test.equals val, 5
    await closePage()
    test.done()
