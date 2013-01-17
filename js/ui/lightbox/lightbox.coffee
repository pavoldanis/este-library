###*
	@fileoverview Lightbox.
	@see ../demos/lightbox.html
###
goog.provide 'este.ui.Lightbox'

goog.require 'este.ui.Component'
goog.require 'este.ui.lightbox.AnchorClickHandler'
goog.require 'este.ui.lightbox.View.create'

class este.ui.Lightbox extends este.ui.Component

	###*
		@param {este.ui.lightbox.AnchorClickHandler} anchorClickHandler
		@param {Function} viewFactory
		@constructor
		@extends {este.ui.Component}
	###
	constructor: (@anchorClickHandler, @viewFactory) ->

	###*
		@return {este.ui.Lightbox}
	###
	@create: ->
		handler = new este.ui.lightbox.AnchorClickHandler
		factory = este.ui.lightbox.View.create
		new Lightbox handler, factory

	###*
		@type {este.ui.lightbox.AnchorClickHandler}
	###
	anchorClickHandler: null

	###*
		@type {Function}
	###
	viewFactory: null

	###*
		@type {este.ui.lightbox.View}
		@protected
	###
	view: null

	###*
		Close view.
	###
	close: ->
		@removeChild @view
		@view.dispose()

	###*
		@override
	###
	decorateInternal: (element) ->
		super element
		@anchorClickHandler.decorate element
		return

	###*
		@override
	###
	enterDocument: ->
		super()
		@on @anchorClickHandler, 'click', @onAnchorClickHandlerClick
		return

	###*
		@param {Object} e
		@protected
	###
	onAnchorClickHandlerClick: (e) ->
		@view = @viewFactory e.currentAnchor, e.anchors
		@addChild @view, true
		@on @view, 'close', @close