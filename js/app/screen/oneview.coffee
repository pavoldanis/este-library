###*
  @fileoverview este.app.screen.OneView.
###
goog.provide 'este.app.screen.OneView'

goog.require 'este.app.screen.Base'

class este.app.screen.OneView extends este.app.screen.Base

  ###*
    @constructor
    @extends {este.app.screen.Base}
  ###
  constructor: ->
    super()

  ###*
    @type {Element}
    @protected
  ###
  previous: null

  ###*
    @override
  ###
  show: (el) ->
    @getElement().removeChild @previous if @previous
    @previous = el
    @getElement().appendChild el

