###*
  @fileoverview este.demos.app.layout.bla.View.
###
goog.provide 'este.demos.app.layout.bla.View'

goog.require 'este.app.View'
goog.require 'este.demos.app.layout.bla.templates'

class este.demos.app.layout.bla.View extends este.app.View

  ###*
    @constructor
    @extends {este.app.View}
  ###
  constructor: ->
    super()

  ###*
    @override
  ###
  registerEvents: ->
    @on @getElement(), 'div click': @onDivClick

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @update()
    return

  ###*
    @protected
  ###
  update: ->
    @getElement().innerHTML = este.demos.app.layout.bla.templates.element()

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onDivClick: (e) ->
    alert '.este-content clicked'