###*
  @fileoverview Add several usefull events related features.
  @see ../demos/component.html

  Features
    on/off aliases for getHandler().listen, getHandler().unlisten
    on is allowed only if component is in document (because exitDocument)
    event delegation for
      DOM events
      key (keyHandler)
      focus blur
      tap
      submit

###
goog.provide 'este.ui.Component'

goog.require 'este.dom'
goog.require 'este.dom.merge'
goog.require 'este.events.Delegation'
goog.require 'este.events.SubmitHandler'
goog.require 'este.events.TapHandler'
goog.require 'goog.asserts'
goog.require 'goog.events.KeyHandler'
goog.require 'goog.object'
goog.require 'goog.string'
goog.require 'goog.ui.Component'

class este.ui.Component extends goog.ui.Component

  ###*
    @param {goog.dom.DomHelper=} domHelper Optional DOM helper.
    @constructor
    @extends {goog.ui.Component}
  ###
  constructor: (domHelper) ->
    super domHelper

  ###*
    @type {Array.<este.events.Delegation>}
    @protected
  ###
  delegations: null

  ###*
    @type {goog.events.KeyHandler}
    @protected
  ###
  keyHandler: null

  ###*
    @type {este.events.TapHandler}
    @protected
  ###
  tapHandler: null

  ###*
    @type {este.events.SubmitHandler}
    @protected
  ###
  submitHandler: null

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @delegations = []
    @keyHandler = null
    @tapHandler = null
    @submitHandler = null
    @registerEvents()
    return

  ###*
    @protected
  ###
  registerEvents: ->

  ###*
    @override
  ###
  exitDocument: ->
    super()
    delegation.dispose() for delegation in @delegations
    @keyHandler?.dispose()
    @tapHandler?.dispose()
    @submitHandler?.dispose()
    return

  ###*
    Examples:
      on getElement(), 'click', onDivClick
      on 'div', 'click', onDivClick
      on 'div click', onDivClick
      on
        'div click': onDivClick
      on content,
        'div click': onDivClick

    @param {goog.events.EventTarget|EventTarget|string|Object.<string, Function|Array>}
      src Event source.
    @param {string|Array.<string>|number|Object.<string, Function|Array>=} type
      Event type to listen for or array of event types or key code number.
    @param {Function|Object=} fn Optional callback function to be used as
      the listener or an object with handleEvent function.
    @param {boolean=} capture Optional whether to use capture phase.
    @param {Object=} handler Object in whose scope to call the listener.
    @protected
  ###
  on: (src, type, fn, capture, handler) ->
    goog.asserts.assert @isInDocument(),
      'This method can be called only if component is in document.'

    if goog.isString src
      switch arguments.length
        when 3
          `fn = /** @type {Function} */ (fn)`
          @on src + ' ' + type, fn
        when 2
          @on @getElement(), goog.object.create src, type
      return

    switch arguments.length
      when 1
        @on @getElement(), src
        return
      when 2
        `type = /** @type {Object.<(Array|Function|null)>} */ (type)`
        `src = /** @type {Element} */ (src)`
        @delegate type, src
        return
      else
        `src = /** @type {EventTarget|goog.events.EventTarget} */ (src)`
        `type = /** @type {string|Array.<string>} */ (type)`
        @getHandler().listen src, type, fn, capture, handler
        return

  ###*
    Just alias for getHandler().unlisten.
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
    @param {Object.<string, Function|Array>} object
    @param {Element=} el
    @protected
  ###
  delegate: (object, el = @getElement()) ->
    for key, value of object
      chunks = (goog.string.trim goog.string.normalizeSpaces key).split ' '
      selector = chunks[0]
      type = chunks[1] || value[0]
      if goog.string.isNumeric type
        # cast to number for keyCodes for key event handler
        type = Number(type)
      else
        type = type.split ',' if ~type.indexOf ','
      fn = if chunks[1] then value else value[1]
      @delegateType selector, type, fn, el
    return

  ###*
    @param {string} selector
    @param {string|Array.<string>|number} type
    @param {Function} fn
    @param {Element} el
    @protected
  ###
  delegateType: (selector, type, fn, el) ->
    if type == 'tap'
      @delegateTapEvents selector, fn, el
    else if type == 'submit'
      @delegateSubmitEvents selector, fn, el
    else if typeof type == 'number'
      @delegateKeyEvents selector, type, fn, el
    else
      @delegateDomEvents selector, type, fn, el

  ###*
    @param {string} selector
    @param {Function} fn
    @param {Element} el
    @protected
  ###
  delegateTapEvents: (selector, fn, el) ->
    @tapHandler ?= new este.events.TapHandler el
    @on @tapHandler, 'tap', (e) ->
      @callDelegateCallbackIfMatched selector, e, fn

  ###*
    @param {string} selector
    @param {Function} fn
    @param {Element} el
    @protected
  ###
  delegateSubmitEvents: (selector, fn, el) ->
    @submitHandler ?= new este.events.SubmitHandler el
    @on @submitHandler, 'submit', (e) ->
      @callDelegateCallbackIfMatched selector, e, fn

  ###*
    @param {string} selector
    @param {number} keyCode
    @param {Function} fn
    @param {Element} el
    @protected
  ###
  delegateKeyEvents: (selector, keyCode, fn, el) ->
    @keyHandler ?= new goog.events.KeyHandler el
    @on @keyHandler, 'key', (e) ->
      return if e.keyCode != keyCode
      @callDelegateCallbackIfMatched selector, e, fn

  ###*
    @param {string} selector
    @param {string|Array.<string>} events
    @param {Function} fn
    @param {Element} el
    @protected
  ###
  delegateDomEvents: (selector, events, fn, el) ->
    matcher = @createSelectorMatcher selector
    delegation = este.events.Delegation.create el, events, matcher
    @delegations.push delegation
    @on delegation, events, fn

  ###*
    @param {string} selector
    @param {goog.events.BrowserEvent} e
    @param {Function} fn
    @protected
  ###
  callDelegateCallbackIfMatched: (selector, e, fn) ->
    matcher = @createSelectorMatcher selector
    target = goog.dom.getAncestor e.target, matcher, true
    return if !target
    e.target = target
    fn.call @, e

  ###*
    @param {string} selector
    @return {function(Node): boolean}
    @protected
  ###
  createSelectorMatcher: (selector) ->
    (el) -> este.dom.match el, selector