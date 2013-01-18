###*
  @fileoverview este.app.Route.
###
goog.provide 'este.app.Route'

goog.require 'este.Base'

class este.app.Route extends este.Base

  ###*
    @param {string} path
    @param {este.app.Presenter} presenter
    @constructor
    @extends {este.Base}
  ###
  constructor: (@path, @presenter) ->
    super()

  ###*
    Path has to start with '/' prefix. If HTML5 pustState is not supported,
    then url will prefixed with with hash ('#/').
    Various url definitions: este/assets/js/este/router/route_test.coffee
    @type {string}
  ###
  path: ''

  ###*
    @type {este.app.Presenter}
  ###
  presenter: null