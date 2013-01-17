###*
  @fileoverview Dev monitor. Small console output at right bottom of screen.
  Useful for mobile development. It also shows total count of registered
  listeners. It's useful to see it and be sure, that app does not leak.
  ex.
    mlog 'foo'
###
goog.provide 'este.dev.Monitor'
goog.provide 'este.dev.Monitor.create'

goog.require 'este.ui.Component'

class este.dev.Monitor extends este.ui.Component

  ###*
    @constructor
    @extends {este.ui.Component}
  ###
  constructor: ->
    super

  ###*
    @return {este.dev.Monitor}
  ###
  @create = ->
    monitor = new Monitor
    monitor.decorate document.body
    monitor

  ###*
    @type {Element}
  ###
  monitor: null

  ###*
    @type {Node}
  ###
  left: null

  ###*
    @type {Node}
  ###
  right: null

  ###*
    @type {?number}
  ###
  timer: null

  ###*
    @override
  ###
  decorateInternal: (element) ->
    super element
    @monitor = @dom_.createDom 'div'
      # absolute instead of fixed, because obsolete mobile devices
      'style': 'white-space: nowrap; font-size: 10px; position: absolute; z-index: 9999999999999; opacity: .8; max-width: 100%; right: 10px; bottom: 0; background-color: #eee; color: #000; padding: .7em;'
    @left = @monitor.appendChild @dom_.createDom 'div'
      'style': 'word-break: break-word; display: inline-block'
      'id': 'devlog'
    @right = @monitor.appendChild @dom_.createDom 'div'
      'style': 'display: inline-block'
    element.appendChild @monitor
    @timer = setInterval =>
      # - 1 because listen(window, 'scroll', @onWindowScroll)
      # dont make user thing about that listener
      @right.innerHTML = '| ' + (goog.events.getTotalListenerCount() - 1)
    , 500
    return

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @on window, 'scroll', @onWindowScroll
    return

  ###*
    @protected
  ###
  onWindowScroll: (e) ->
    bottom = -@dom_.getDocumentScroll().y
    @monitor.style.bottom = (bottom + 10) + 'px'

  ###*
    @override
  ###
  disposeInternal: ->
    clearInterval @timer
    @getElement().removeChild @monitor
    super()
    return