###*
  @fileoverview este.demos.app.layout.foo.Presenter.
###
goog.provide 'este.demos.app.layout.foo.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.layout.foo.View'
goog.require 'este.demos.app.layout.layouts.sidebar.View'

class este.demos.app.layout.foo.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    @view = new este.demos.app.layout.layouts.sidebar.View
      content: new este.demos.app.layout.foo.View
    super()