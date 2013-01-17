###*
	@fileoverview este.ui.resizer.Handles'
###
goog.provide 'este.ui.resizer.Handles'
goog.provide 'este.ui.resizer.Handles.create'

goog.require 'este.ui.Component'
goog.require 'goog.fx.Dragger'
goog.require 'goog.math.Coordinate'
goog.require 'este.ui.InvisibleOverlay.create'

class este.ui.resizer.Handles extends este.ui.Component

	###*
		@param {Function} draggerFactory
		@param {Function} invisibleOverlayFactory
		@constructor
		@extends {este.ui.Component}
	###
	constructor: (@draggerFactory, @invisibleOverlayFactory) ->

	###*
		@return {este.ui.resizer.Handles}
	###
	@create = ->
		draggerFactory = ->
			dragger = new goog.fx.Dragger document.createElement 'div'
			dragger
		new Handles draggerFactory, este.ui.InvisibleOverlay.create

	###*
		@enum {string}
	###
	@EventType:
		# just relayed event from handles elements
		MOUSEOUT: 'mouseout'
		START: 'start'
		DRAG: 'drag'
		END: 'end'

	###*
		@type {Element}
	###
	vertical: null

	###*
		@type {Element}
	###
	horizontal: null

	###*
		@type {Element}
	###
	activeHandle: null

	###*
		@type {Function}
	###
	draggerFactory: null

	###*
		@type {Function}
	###
	invisibleOverlayFactory: null

	###*
		@type {goog.fx.Dragger}
	###
	dragger: null

	###*
		@type {goog.math.Coordinate}
	###
	dragMouseStart: null

	###*
		@type {este.ui.InvisibleOverlay}
	###
	invisibleOverlay: null

	###*
		@override
	###
	decorateInternal: (element) ->
		super element
		@createHandles()
		@update()
		return

	###*
		@protected
	###
	createHandles: ->
		@vertical = @dom_.createDom 'div', 'e-resizer-handle-vertical'
		@horizontal = @dom_.createDom 'div', 'e-resizer-handle-horizontal'
		parent = @getElement().offsetParent || @getElement()
		parent.appendChild @vertical
		parent.appendChild @horizontal

	###*
		Update handles bounds.
		@protected
	###
	update: ->
		el = @getElement()
		left = el.offsetLeft
		top = el.offsetTop
		goog.style.setPosition @horizontal, left, top + el.offsetHeight
		goog.style.setWidth @horizontal, el.offsetWidth

		goog.style.setPosition @vertical, left + el.offsetWidth, top
		goog.style.setHeight @vertical, el.offsetHeight

	###*
		@override
	###
	enterDocument: ->
		super()
		@on @horizontal, 'mousedown', @onHorizontalMouseDown
		@on @vertical, 'mousedown', @onVerticalMouseDown
		@on @horizontal, 'mouseout', @onMouseOut
		@on @vertical, 'mouseout', @onMouseOut
		return

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onHorizontalMouseDown: (e) ->
		@activeHandle = @horizontal
		@startDrag e

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onVerticalMouseDown: (e) ->
		@activeHandle = @vertical
		@startDrag e

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onMouseOut: (e) ->
		@dispatchEvent e

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	startDrag: (e) ->
		@dragger = @draggerFactory()
		@on @dragger, 'start', @onDragStart
		@on @dragger, 'drag', @onDrag
		@on @dragger, 'end', @onDragEnd
		@dragger.startDrag e

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	onDragStart: (e) ->
		@invisibleOverlay = @invisibleOverlayFactory()
		@addChild @invisibleOverlay, false
		@invisibleOverlay.render @dom_.getDocument().body
		@invisibleOverlay.getElement().style.cursor = goog.style.getComputedCursor @activeHandle
		@dragMouseStart = new goog.math.Coordinate e.clientX, e.clientY
		@dispatchEvent
			element: @getElement()
			vertical: @activeHandle == @vertical
			type: Handles.EventType.START

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	onDrag: (e) ->
		mouseCoord = new goog.math.Coordinate e.clientX, e.clientY
		`var dragMouseStart = /** @type {!goog.math.Coordinate} */ (this.dragMouseStart)`
		difference = goog.math.Coordinate.difference mouseCoord, dragMouseStart
		@dispatchEvent
			element: @getElement()
			vertical: @activeHandle == @vertical
			type: Handles.EventType.DRAG
			width: difference.x
			height: difference.y
		@update()

	###*
		@param {goog.fx.DragEvent} e
		@protected
	###
	onDragEnd: (e) ->
		@removeChild @invisibleOverlay, true
		@dragger.dispose()
		@dispatchEvent
			element: @getElement()
			type: Handles.EventType.END
			close: @shouldClose e

	###*
		@param {goog.fx.DragEvent} e
		@return {boolean}
		@protected
	###
	shouldClose: (e) ->
		el = @dom_.getDocument().elementFromPoint e.clientX, e.clientY
		!(el in [@horizontal, @vertical])

	###*
		@param {Node} element
	###
	isHandle: (element) ->
		element in [@vertical, @horizontal]

	###*
		@override
	###
	disposeInternal: ->
		@dom_.removeNode @horizontal
		@dom_.removeNode @vertical
		@dragger.dispose() if @dragger
		super()
		return