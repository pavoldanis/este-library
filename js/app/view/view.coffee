###*
  @fileoverview este.app.View.
###
goog.provide 'este.app.View'

goog.require 'este.ui.View'

class este.app.View extends este.ui.View

  ###*
    @constructor
    @extends {este.ui.View}
  ###
  constructor: ->
    super()

  ###*
    @type {?function(function(new:este.app.Presenter), Object=): string}
  ###
  createUrl: null

  ###*
    @type {?function(function(new:este.app.Presenter), Object=): string}
  ###
  redirect: null