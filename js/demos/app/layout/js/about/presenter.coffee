###*
  @fileoverview este.demos.app.layout.about.Presenter.
###
goog.provide 'este.demos.app.layout.about.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.layout.about.View'
goog.require 'este.demos.app.layout.layouts.master.View'

class este.demos.app.layout.about.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    @view = new este.demos.app.layout.layouts.master.View
      content: new este.demos.app.layout.about.View
    super()