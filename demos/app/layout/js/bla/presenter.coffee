###*
  @fileoverview este.demos.app.layout.bla.Presenter.
###
goog.provide 'este.demos.app.layout.bla.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.layout.bla.View'
goog.require 'este.demos.app.layout.layouts.sidebar.View'

class este.demos.app.layout.bla.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    @view = new este.demos.app.layout.layouts.sidebar.View
      content: new este.demos.app.layout.bla.View
    super