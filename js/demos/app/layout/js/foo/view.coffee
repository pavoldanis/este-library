###*
  @fileoverview este.demos.app.layout.foo.View.
###
goog.provide 'este.demos.app.layout.foo.View'

goog.require 'este.app.View'
goog.require 'este.demos.app.layout.foo.templates'
goog.require 'este.ui.Resizer'

class este.demos.app.layout.foo.View extends este.app.View

  ###*
    @constructor
    @extends {este.app.View}
  ###
  constructor: ->
    super()

  ###*
    @type {este.ui.Resizer}
    @protected
  ###
  resizer: null

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @update()
    @createResiser()
    return

  ###*
    @override
  ###
  exitDocument: ->
    super()
    @resizer.dispose()
    return

  ###*
    @protected
  ###
  update: ->
    @getElement().innerHTML = este.demos.app.layout.foo.templates.element()

  ###*
    @protected
  ###
  createResiser: ->
    @resizer = este.ui.Resizer.create()
    @resizer.targetFilter = (el) =>
      goog.dom.classes.has el, 'este-box'
    @resizer.decorate @getElement()