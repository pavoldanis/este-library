###*
  @fileoverview este.app.Presenter.
###
goog.provide 'este.app.Presenter'

goog.require 'este.app.View'
goog.require 'este.Base'
goog.require 'este.result'

class este.app.Presenter extends este.Base

  ###*
    @constructor
    @extends {este.Base}
  ###
  constructor: ->
    super()

  ###*
    @type {este.app.View}
    @protected
  ###
  view: null

  ###*
    @type {este.storage.Base}
  ###
  storage: null

  ###*
    @type {este.app.screen.Base}
  ###
  screen: null

  ###*
    @type {?function(function(new:este.app.Presenter), Object=): string}
  ###
  createUrl: null

  ###*
    @type {?function(function(new:este.app.Presenter), Object=): string}
  ###
  redirect: null

  ###*
    Load method has to return object implementing goog.result.Result interface.
    This method should be overridden.
    @param {Object=} params
    @return {!goog.result.Result}
  ###
  load: (params) ->
    este.result.ok()

  ###*
    Called If load were successful and not canceled.
  ###
  show: ->
    return if !@view
    @view.createUrl = @createUrl
    @view.redirect = @redirect
    if @view.getElement()
      @view.enterDocument()
    else
      @view.render @screen.getElement()
    @screen.show @view.getElement()

  ###*
    Called by este.App when another presenter is shown.
  ###
  hide: ->
    @view.exitDocument()

  ###*
    @override
  ###
  disposeInternal: ->
    @view.dispose()
    super()
    return