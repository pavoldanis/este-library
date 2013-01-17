###*
  @fileoverview este.demos.app.layout.layouts.sidebar.View.
###
goog.provide 'este.demos.app.layout.layouts.sidebar.View'

goog.require 'este.demos.app.layout.layouts.master.View'
goog.require 'este.demos.app.layout.foo.View'
goog.require 'este.demos.app.layout.bla.View'

class este.demos.app.layout.layouts.sidebar.View extends este.demos.app.layout.layouts.master.View

  ###*
    @param {Object.<string, este.app.View>} views
    @constructor
    @extends {este.demos.app.layout.layouts.master.View}
  ###
  constructor: (views) ->
    super views

  ###*
    @override
  ###
  renderSidebar: (el) ->
    el.innerHTML = este.app.renderLinks @, [
      title: 'Foo'
      presenter: este.demos.app.layout.foo.Presenter
      selected: @content instanceof este.demos.app.layout.foo.View
    ,
      title: 'Bla'
      presenter: este.demos.app.layout.bla.Presenter
      selected: @content instanceof este.demos.app.layout.bla.View
    ]