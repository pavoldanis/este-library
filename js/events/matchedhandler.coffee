###*
  @fileoverview Event matched by a simple selector, ex.:
  handler = new este.events.MatchedHandler el, [
    id: 123
    container: '.pw1001'
    child: '.highlightEbook'
    link: 'a'
  , ..
  ]
  goog.events.listen handler, 'click', (e) ->
    #e.id == 123
    #e.childIndex = 1
###
goog.provide 'este.events.MatchedHandler'
goog.provide 'este.events.MatchedHandler.create'
goog.provide 'este.events.MatchedHandler.Matcher'

goog.require 'goog.events.EventTarget'
goog.require 'este.dom'

class este.events.MatchedHandler extends goog.events.EventTarget

  ###*
    @param {Element} element
    @param {Array.<este.events.MatchedHandler.Matcher>} matchers
    @param {Function} getChildIndex
    @param {string=} opt_eventType
    @constructor
    @extends {goog.events.EventTarget}
  ###
  constructor: (@element, @matchers, @getChildIndex, opt_eventType) ->
    super()
    @listenKey_ = goog.events.listen @element, opt_eventType ? 'click', @
    return

  ###*
    @param {Element} element
    @param {Array.<este.events.MatchedHandler.Matcher>} matchers
    @return {este.events.MatchedHandler}
  ###
  @create: (element, matchers) ->
    new MatchedHandler element, matchers, MatchedHandler.getChildIndex

  ###*
    Compute child index, no CSS selector engine, solid and fast.
    @param {Element} container
    @param {Element} child
    @param {string} childMatcher
    @return {number}
  ###
  @getChildIndex: (container, child, childMatcher) ->
    index = 0
    for item in goog.array.toArray container.getElementsByTagName '*'
      if este.dom.match item, childMatcher
        return index if item == child
        index++
    -1

  ###*
    @type {Element}
  ###
  element: null

  ###*
    @type {Array.<este.events.MatchedHandler.Matcher>}
  ###
  matchers: null

  ###*
    @type {Function}
  ###
  getChildIndex: null

  ###*
    @type {?number}
    @private
  ###
  listenKey_: null

  ###*
    @param {goog.events.BrowserEvent} e
  ###
  handleEvent: (e) ->
    target = e.target
    ancestors = este.dom.getAncestors target, true, true
    for matcher in @matchers
      matchers = [matcher['link'], matcher['child'], matcher['container']]
      container = null
      child = null
      index = 0
      for ancestor in ancestors
        break if container
        continue if !este.dom.match ancestor, matchers[index]
        switch index
          when 1 then child = ancestor
          when 2 then container = ancestor
        index++
      continue if !container
      childIndex = @getChildIndex container, child, matcher['child']
      @dispatchEvent
        target: target
        type: e.type
        id: matcher['id']
        childIndex: childIndex
      return
    ancestors.reverse()
    @dispatchEvent
      target: target
      type: e.type
      domPath: este.dom.getDomPath ancestors

  ###*
    @override
  ###
  disposeInternal: ->
    super()
    goog.events.unlistenByKey @listenKey_
    delete @listenKey_
    return

###*
  @typedef {{id: string, container: string, child: string, link: string}}
###
este.events.MatchedHandler.Matcher