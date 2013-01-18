###*
  @fileoverview Base class for classes using events.
###
goog.provide 'este.Base'

goog.require 'goog.asserts'
goog.require 'goog.events.EventHandler'
goog.require 'goog.events.EventTarget'

class este.Base extends goog.events.EventTarget

  ###*
    @constructor
    @extends {goog.events.EventTarget}
  ###
  constructor: ->
    super()
    @parents_ = []

  ###*
    @type {goog.events.EventHandler}
    @private
  ###
  handler_: null

  ###*
    @type {Array.<este.Base>}
  ###
  parents_: null

  ###*
    @protected
  ###
  getHandler: ->
    @handler_ ?= new goog.events.EventHandler @

  ###*
    Alias for .listen.
    @param {goog.events.EventTarget|EventTarget} src Event source.
    @param {string|Array.<string>} type Event type to listen for or array of
      event types.
    @param {Function|Object=} fn Optional callback function to be used as
      the listener or an object with handleEvent function.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  on: (src, type, fn, capture, handler) ->
    @getHandler().listen src, type, fn, capture, handler

  ###*
    Alias for .listenOnce.
    @param {goog.events.EventTarget|EventTarget} src Event source.
    @param {string|Array.<string>} type Event type to listen for or array of
      event types.
    @param {Function|Object=} fn Optional callback function to be used as
      the listener or an object with handleEvent function.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  once: (src, type, fn, capture, handler) ->
    @getHandler().listenOnce src, type, fn, capture, handler

  ###*
    Alias for .unlisten.
    @param {goog.events.EventTarget|EventTarget} src Event source.
    @param {string|Array.<string>} type Event type to listen for or array of
      event types.
    @param {Function|Object=} fn Optional callback function to be used as
      the listener or an object with handleEvent function.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  off: (src, type, fn, capture, handler) ->
    @getHandler().unlisten src, type, fn, capture, handler

  ###*
    @param {este.Base} parent
    @protected
  ###
  addParent: (parent) ->
    goog.array.insert @parents_, parent

  ###*
    @param {este.Base} parent
    @return {boolean} True if an element was removed.
    @protected
  ###
  removeParent: (parent) ->
    goog.array.remove @parents_, parent

  ###*
    Return clone of the parents.
    @return {Array.<este.Base>}
    @protected
  ###
  getParents: ->
    @parents_.slice 0

  ###*
    @override
  ###
  dispatchEvent: (e) ->
    result = goog.events.dispatchEvent @, e
    return false if !result
    for parent in @getParents()
      result = goog.events.dispatchEvent parent, e
      return false if !result
    true

  ###*
    @override
  ###
  disposeInternal: ->
    @handler_?.dispose()
    @parents_ = null
    super()
    return