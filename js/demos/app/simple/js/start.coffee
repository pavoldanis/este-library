###*
  @fileoverview este.demos.app.simple.start.
###

goog.provide 'este.demos.app.simple.start'

goog.require 'este.app.create'
goog.require 'este.demos.app.simple.product.Presenter'
goog.require 'este.demos.app.simple.products.Presenter'
goog.require 'este.dev.Monitor.create'

###*
  @param {Object} data JSON from server
###
este.demos.app.simple.start = (data) ->

  if goog.DEBUG
    este.dev.Monitor.create()

  forceHash = false
  app = este.app.create 'simple-app', forceHash

  productPresenter = new este.demos.app.simple.product.Presenter
  productsPresenter = new este.demos.app.simple.products.Presenter

  app.routes = [
    new este.app.Route '/product/:id', productPresenter
    new este.app.Route '/', productsPresenter
  ]

  # app loading progress bar
  progressEl = document.getElementById 'progress'
  timer = null
  goog.events.listen app, 'load', (e) ->
    goog.dom.classes.add progressEl, 'loading'
    progressEl.innerHTML = 'loading'
    progressEl.innerHTML += ' ' + e.request.params.id if e.request.params?.id
    clearInterval timer
    timer = setInterval ->
      progressEl.innerHTML += '.'
    , 250
  goog.events.listen app, 'show', (e) ->
    clearInterval timer
    goog.dom.classes.remove progressEl, 'loading'
    progressEl.innerHTML = 'loaded'

  app.start()

  # dispose app
  goog.events.listenOnce document.body, 'click', (e) ->
    if e.target.id == 'dispose'
      app.dispose()
      e.target.disabled = true
      e.target.innerHTML = 'disposed'

# ensures the symbol will be visible after compiler renaming
goog.exportSymbol 'este.demos.app.simple.start', este.demos.app.simple.start