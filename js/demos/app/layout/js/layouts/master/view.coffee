###*
  @fileoverview este.demos.app.layout.layouts.master.View.
###
goog.provide 'este.demos.app.layout.layouts.master.View'

goog.require 'este.app.View'
goog.require 'este.demos.app.layout.layouts.master.templates'

class este.demos.app.layout.layouts.master.View extends este.app.View

  ###*
    @param {Object.<string, este.app.View>} views
    @constructor
    @extends {este.app.View}
  ###
  constructor: (views) ->
    @content = views.content
    @addChild @content
    super()

  ###*
    @type {este.app.View}
    @protected
  ###
  content: null

  ###*
    @override
  ###
  createDom: ->
    super()
    @getElement().innerHTML =
      este.demos.app.layout.layouts.master.templates.element()
    @renderLinks @getElementByClass 'este-links'
    @content.render @getElementByClass 'este-content'
    @renderSidebar @getElementByClass 'este-sidebar'
    return

  ###*
    @param {Element} el
    @protected
  ###
  renderLinks: (el) ->
    el.innerHTML = este.app.renderLinks @, [
      title: 'Home'
      presenter: este.demos.app.layout.home.Presenter
      selected:
        @content instanceof este.demos.app.layout.home.View ||
        @content instanceof este.demos.app.layout.bla.View ||
        @content instanceof este.demos.app.layout.foo.View
    ,
      title: 'About'
      presenter: este.demos.app.layout.about.Presenter
      selected: @content instanceof este.demos.app.layout.about.View
    ,
      title: 'Contacts'
      presenter: este.demos.app.layout.contacts.Presenter
      selected: @content instanceof este.demos.app.layout.contacts.View
    ]

  ###*
    @param {Element} el
    @protected
  ###
  renderSidebar: (el) ->
    @dom_.removeNode el