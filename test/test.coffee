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
gotoPage = (path) ->
  browser = await puppeteer.launch()
  page = await browser.newPage()
  await page.goto 'http://localhost:23232/' + (path or '')
closePage = ->
  await browser.close()
  ws.server.close()
waitForRendered = ->
  await page.evaluate () ->
    new Promise (resolve) ->
      window.app.$on 'rendered', ->
        resolve()
      window.app.render()

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
    test.ok await page.evaluate () -> document.querySelector('scene[name="home"].yma-router-active')
    test.ok await page.evaluate () -> document.querySelector('scene[name="about"].yma-router-parked')
    test.ok await page.evaluate () -> document.querySelector('scene[name="users"].yma-router-parked')
    await closePage()
    test.done()
  "Should display about scene": (test) ->
    makeServer 'test/router-basic'
    await gotoPage 'about'
    await waitForRendered()
    test.ok await page.evaluate () -> document.querySelector('scene[name="about"].yma-router-active')
    test.ok await page.evaluate () -> document.querySelector('scene[name="home"].yma-router-parked')
    test.ok await page.evaluate () -> document.querySelector('scene[name="users"].yma-router-parked')
    await closePage()
    test.done()
  "Should display users scene": (test) ->
    makeServer 'test/router-basic'
    await gotoPage 'users'
    await waitForRendered()
    test.ok await page.evaluate () -> document.querySelector('scene[name="users"].yma-router-active')
    test.ok await page.evaluate () -> document.querySelector('scene[name="home"].yma-router-parked')
    test.ok await page.evaluate () -> document.querySelector('scene[name="about"].yma-router-parked')
    await closePage()
    test.done()
