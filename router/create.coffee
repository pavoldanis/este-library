###*
  @fileoverview Router factory.
  @see ../demos/router.html
###
goog.provide 'este.router.create'

goog.require 'este.events.TapHandler'
goog.require 'este.History'
goog.require 'este.Router'

###*
  @param {Element=} element
  @param {boolean=} forceHash
  @param {string=} pathPrefix Should start and end with slash.
  @return {este.Router}
###
este.router.create = (element = document.body, forceHash, pathPrefix) ->
  history = new este.History forceHash, pathPrefix
  tapHandler = new este.events.TapHandler element
  new este.Router history, tapHandler