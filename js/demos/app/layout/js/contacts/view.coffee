###*
  @fileoverview este.demos.app.layout.contacts.View.
###
goog.provide 'este.demos.app.layout.contacts.View'

goog.require 'este.app.View'

class este.demos.app.layout.contacts.View extends este.app.View

  ###*
    @constructor
    @extends {este.app.View}
  ###
  constructor: ->
    super()

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
    @getElement().innerHTML = 'Contacts content.'