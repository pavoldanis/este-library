###*
  @fileoverview TapHandler is general tap event both for mobile and desktop.
  For touch devices, touchstart is used, which fixes 300ms click delay.
  This approach is also known as FastButton, but TapHandler implementation
  is better, because works fine with native mobile scroll momentum.
  @see ../demos/taphandler.html
###
goog.provide 'este.events.TapHandler'
goog.provide 'este.events.TapHandler.EventType'

goog.require 'este.Base'
goog.require 'este.mobile'
goog.require 'goog.dom'
goog.require 'goog.math.Coordinate'
goog.require 'goog.userAgent'

class este.events.TapHandler extends este.Base

  ###*
    @param {Element} element
    @param {boolean=} touchSupported
    @constructor
    @extends {este.Base}
  ###
  constructor: (@element, touchSupported) ->
    super
    @touchSupported = touchSupported ? TapHandler.touchSupported()
    @registerEvents()

  ###*
    @enum {string}
  ###
  @EventType:
    START: 'start'
    END: 'end'
    TAP: 'tap'

  ###*
    Touchstart on iOS<5 slowdown native scrolling, 4.3.2 does not fire
    touchstart on search input field etc..., so that's why iOS5 is required.
    @return {boolean}
  ###
  @touchSupported: ->
    return false if !goog.userAgent.MOBILE
    !este.mobile.iosVersion || este.mobile.iosVersion >= 5

  ###*
    @param {goog.events.BrowserEvent} e
    @return {!goog.math.Coordinate}
  ###
  @getTouchClients: (e) ->
    touches = e.getBrowserEvent().touches[0]
    new goog.math.Coordinate touches.clientX, touches.clientY

  ###*
    @param {Node} target
    @return {Node}
  ###
  @ensureTargetIsElement: (target) ->
    # IOS4 bug: touch events are fired on text nodes
    target = target.parentNode if target.nodeType == 3
    target

  ###*
    @type {number}
  ###
  touchMoveSnap: 10

  ###*
    @type {number}
  ###
  touchEndTimeout: 10

  ###*
    @type {Element}
    @protected
  ###
  element: null

  ###*
    @type {boolean}
    @protected
  ###
  touchSupported: false

  ###*
    @type {goog.math.Coordinate}
    @protected
  ###
  coordinate: null

  ###*
    @type {boolean}
    @protected
  ###
  scrolled: false

  ###*
    @return {Element}
  ###
  getElement: ->
    @element

  ###*
    @protected
  ###
  registerEvents: ->
    if @touchSupported
      @on @element, 'touchstart', @onTouchStart
      @on @getScrollObject(), 'scroll', @onScroll
    else
      @on @element, 'click', @onClick

  ###*
    @protected
  ###
  getScrollObject: ->
    if @element.tagName == 'BODY'
      goog.dom.getWindow @element.ownerDocument
    else
      @element

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTouchStart: (e) ->
    @coordinate = TapHandler.getTouchClients e
    @scrolled = false
    @enableTouchMoveEndEvents true
    @dispatchTapEvent TapHandler.EventType.START, e.target

  ###*
    @param {boolean} enable
    @protected
  ###
  enableTouchMoveEndEvents: (enable) ->
    html = @element.ownerDocument.documentElement
    if enable
      @on html, 'touchmove', @onTouchMove
      @on @element, 'touchend', @onTouchEnd
    else
      @off html, 'touchmove', @onTouchMove
      @off @element, 'touchend', @onTouchEnd

  ###*
    @param {string} type
    @param {Node} target
    @param {goog.events.BrowserEvent=} clickEvent
    @protected
  ###
  dispatchTapEvent: (type, target, clickEvent) ->
    target = TapHandler.ensureTargetIsElement target
    return if !target
    @dispatchEvent
      type: type
      target: target
      clickEvent: clickEvent

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTouchMove: (e) ->
    return if !@coordinate? # because compiler needs !null
    distance = goog.math.Coordinate.distance @coordinate,
      TapHandler.getTouchClients e
    return if distance < @touchMoveSnap
    @dispatchTapEvent TapHandler.EventType.END, e.target
    @enableTouchMoveEndEvents false

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTouchEnd: (e) ->
    target = e.target
    @enableTouchMoveEndEvents false
    setTimeout =>
      @dispatchTapEvent TapHandler.EventType.END, target
      return if @scrolled
      @dispatchTapEvent TapHandler.EventType.TAP, target
    , @touchEndTimeout

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onScroll: (e) ->
    @scrolled = true

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onClick: (e) ->
    @dispatchTapEvent TapHandler.EventType.START, e.target
    @dispatchTapEvent TapHandler.EventType.END, e.target
    @dispatchTapEvent TapHandler.EventType.TAP, e.target, e
