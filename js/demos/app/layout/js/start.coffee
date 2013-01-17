###*
  @fileoverview este.demos.app.layout.start.
###

goog.provide 'este.demos.app.layout.start'

goog.require 'este.app.create'
goog.require 'este.demos.app.layout.about.Presenter'
goog.require 'este.demos.app.layout.bla.Presenter'
goog.require 'este.demos.app.layout.contacts.Presenter'
goog.require 'este.demos.app.layout.foo.Presenter'
goog.require 'este.demos.app.layout.home.Presenter'
goog.require 'este.dev.Monitor.create'

###*
  @param {Object} data JSON from server
###
este.demos.app.layout.start = (data) ->

  if goog.DEBUG
    este.dev.Monitor.create()

  app = este.app.create 'layout-app', true

  aboutPresenter = new este.demos.app.layout.about.Presenter
  blaPresenter = new este.demos.app.layout.bla.Presenter
  contactsPresenter = new este.demos.app.layout.contacts.Presenter
  fooPresenter = new este.demos.app.layout.foo.Presenter
  homePresenter = new este.demos.app.layout.home.Presenter

  app.routes = [
    new este.app.Route '/', homePresenter
    new este.app.Route '/about', aboutPresenter
    new este.app.Route '/contacts', contactsPresenter
    new este.app.Route '/home/bla', blaPresenter
    new este.app.Route '/home/foo', fooPresenter
  ]

  app.start()

# ensures the symbol will be visible after compiler renaming
goog.exportSymbol 'este.demos.app.layout.start', este.demos.app.layout.start