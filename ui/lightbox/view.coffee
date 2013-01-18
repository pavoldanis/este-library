###
	@fileoverview este.ui.lightbox.View.
###

goog.provide 'este.ui.lightbox.View'
goog.provide 'este.ui.lightbox.View.create'

goog.require 'este.ui.Component'
goog.require 'goog.events.KeyCodes'

class este.ui.lightbox.View extends este.ui.Component

	###*
		@param {Element} currentAnchor
		@param {Array.<Element>} anchors
		@constructor
		@extends {este.ui.Component}
	###
	constructor: (@currentAnchor, @anchors) ->
		super()

	###*
		Factory method.
		@param {Element} currentAnchor
		@param {Array.<Element>} anchors
	###
	@create = (currentAnchor, anchors) ->
		new View currentAnchor, anchors

	###*
		@type {Element}
	###
	currentAnchor: null

	###*
		@type {Array.<Element>}
	###
	anchors: null

	###*
		@override
	###
	createDom: ->
		super()
		@getElement().className = 'e-ui-lightbox'
		@updateInternal()
		return

	###*
		@protected
	###
	updateInternal: ->
		imageSrc = @currentAnchor.href
		title = @currentAnchor.title
		firstDisabled = secondDisabled = ''
		currentAnchorIdx = goog.array.indexOf @anchors, @currentAnchor
		totalAnchorsCount = @anchors.length
		if @currentAnchor == @anchors[0]
			firstDisabled = ' e-ui-lightbox-disabled'
		if @currentAnchor == @anchors[totalAnchorsCount - 1]
			secondDisabled = ' e-ui-lightbox-disabled'
		@getElement().innerHTML = "
			<div class='e-ui-lightbox-background'></div>
			<div class='e-ui-lightbox-content'>
				<div class='e-ui-lightbox-image-wrapper'>
					<img class='e-ui-lightbox-image' src='#{imageSrc}'>
					<div class='e-ui-lightbox-title'>#{title}</div>
				</div>
			</div>
			<div class='e-ui-lightbox-sidebar'>
				<button class='e-ui-lightbox-previous#{firstDisabled}'>previous</button>
				<button class='e-ui-lightbox-next#{secondDisabled}'>next</button>
				<div class='e-ui-lightbox-numbers'>
					<span class='e-ui-lightbox-current'>#{currentAnchorIdx + 1}</span>/
					<span class='e-ui-lightbox-total'>#{totalAnchorsCount}</span>
				</div>
				<button class='e-ui-lightbox-close'>close</button>
			</div>"

	###*
		@override
	###
	enterDocument: ->
		super()
		@on @getElement(), 'click', @onClick
		@on @dom_.getDocument(), 'keydown', @onDocumentKeydown
		return

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onClick: (e) ->
		switch e.target.className
			when 'e-ui-lightbox-previous'
				@moveToNextImage false
			when 'e-ui-lightbox-next'
				@moveToNextImage true
			when 'e-ui-lightbox-close'
				@dispatchCloseEvent()

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onDocumentKeydown: (e) ->
		switch e.keyCode
			when goog.events.KeyCodes.ESC
				@dispatchCloseEvent()
			when goog.events.KeyCodes.RIGHT, goog.events.KeyCodes.DOWN
				@moveToNextImage true
			when goog.events.KeyCodes.LEFT, goog.events.KeyCodes.UP
				@moveToNextImage false

	###*
		@param {boolean} next
		@protected
	###
	moveToNextImage: (next) ->
		@setNextCurrentAnchor next
		@updateInternal()

	###*
		@param {boolean} next
		@protected
	###
	setNextCurrentAnchor: (next) ->
		idx = goog.array.indexOf @anchors, @currentAnchor
		if next then idx++ else idx--
		anchor = @anchors[idx]
		return if !anchor
		@currentAnchor = anchor

	###*
		@protected
	###
	dispatchCloseEvent: ->
		@dispatchEvent 'close'