###*
  @fileoverview DomReady ported from jQuery. IE workaround does not work in
  frame so there is no need to inject document. Ready event is fired once.
  .. listen este.events.domReady, 'ready', (e) ->
  Manually tested.
###

goog.provide 'este.events.domReady'
goog.provide 'este.events.DomReadyHandler'

goog.require 'goog.events.EventHandler'
goog.require 'goog.events.EventTarget'

class este.events.DomReadyHandler extends goog.events.EventTarget

  ###*
    @constructor
    @extends {goog.events.EventTarget}
  ###
  constructor: ->
    super()
    if document.readyState == 'complete'
      setTimeout =>
        @dispatchReadyEvent()
      , 1
    else
      @handler = new goog.events.EventHandler @
      @registerEvents()
    return

  ###*
    @enum {string}
  ###
  @EventType:
    READY: 'ready'

  ###*
    @type {goog.events.EventHandler}
  ###
  handler: null

  ###*
    @protected
  ###
  registerEvents: ->
    if document.addEventListener
      @handler.listen document, 'DOMContentLoaded', @onReady
    else
      @handler.listen document, 'readystatechange', @onReadyStateChange
      @doScrollCheck() if @canDoScrollCheck()
    @handler.listen window, 'load', @onReady

  ###*
    @return {boolean}
    @protected
  ###
  canDoScrollCheck: ->
    topLevel = false
    try topLevel = window.frameElement == null
    catch e
    topLevel && !!document.documentElement.doScroll

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onReady: (e) ->
    @dispatchReadyEvent()

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onReadyStateChange: (e) ->
    return if document.readyState != 'complete'
    @dispatchReadyEvent()

  ###*
    @protected
  ###
  doScrollCheck: ->
    try
      document.documentElement.doScroll 'left'
    catch e
      setTimeout =>
        @doScrollCheck()
      , 1
      return
    @dispatchReadyEvent()

  ###*
    @protected
  ###
  dispatchReadyEvent: ->
    @dispatchEvent 'ready'
    @handler?.dispose()

  ###*
    @override
  ###
  disposeInternal: ->
    super()
    @handler?.dispose()
    return

este.events.domReady = new este.events.DomReadyHandler