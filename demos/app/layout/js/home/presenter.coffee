###*
  @fileoverview este.demos.app.layout.home.Presenter.
###
goog.provide 'este.demos.app.layout.home.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.layout.home.View'
goog.require 'este.demos.app.layout.layouts.sidebar.View'

class este.demos.app.layout.home.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    @view = new este.demos.app.layout.layouts.sidebar.View
      content: new este.demos.app.layout.home.View
    super()