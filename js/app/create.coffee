###*
  @fileoverview este.App factory.
###
goog.provide 'este.app.create'

goog.require 'este.App'
goog.require 'este.router.create'
goog.require 'este.app.screen.OneView'

###*
  @param {string|Element} element
  @param {boolean=} forceHash
  @return {este.App}
###
este.app.create = (element, forceHash) ->
  element = goog.dom.getElement element
  router = este.router.create element, forceHash
  app = new este.App router
  screen = new este.app.screen.OneView
  screen.decorate element
  app.screen = screen
  app