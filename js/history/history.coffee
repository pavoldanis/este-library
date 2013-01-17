###*
  @fileoverview HTML5 pushState and hashchange history. Facade for goog.History
  and goog.history.Html5History. It dispatches goog.history.Event.

  Some browsers fires popstate event on page load. It's wrong, because we want
  to control navigate event dispatching separately. These ghost popstate events
  are filtered via location.href check.

  @see ../demos/historyhtml5.html
  @see ../demos/historyhash.html
###

goog.provide 'este.History'

goog.require 'este.Base'
goog.require 'este.history.TokenTransformer'
goog.require 'este.mobile'
goog.require 'este.string'
goog.require 'goog.dom'
goog.require 'goog.History'
goog.require 'goog.history.Event'
goog.require 'goog.history.Html5History'
goog.require 'goog.Uri'
goog.require 'goog.userAgent.product.isVersion'

class este.History extends este.Base

  ###*
    @param {boolean=} forceHash If true, este.History will degrade to hash even
    if html5history is supported.
    @param {string=} pathPrefix Path prefix to use if storing tokens in the path.
    The path prefix should start and end with slash.
    @constructor
    @extends {este.Base}
  ###
  constructor: (forceHash, pathPrefix) ->
    super

    if !pathPrefix
      pathPrefix = new goog.Uri(document.location.href).getPath()
      pathPrefix += '/' if !goog.string.endsWith pathPrefix, '/'

    html5historySupported = goog.history.Html5History.isSupported()

    # iOS < 5 does not support pushState correctly
    if este.mobile.iosVersion && este.mobile.iosVersion < 5
      html5historySupported = false

    # Android 2.x is forced to use hash-based history due to a bug in Android's
    # HTML5 history implementation. This bug does not affect Android 3.0 and
    # higher.
    if goog.userAgent.product.ANDROID && !goog.userAgent.product.isVersion 3
      html5historySupported = false

    @html5historyEnabled = html5historySupported && !forceHash
    @setHistoryInternal pathPrefix ? '/'

  ###*
    @type {boolean}
  ###
  html5historyEnabled: true

  ###*
    @type {goog.History|goog.history.Html5History}
    @protected
  ###
  history: null

  ###*
    @type {goog.events.EventHandler}
    @protected
  ###
  handler: null

  ###*
    @type {boolean}
    @protected
  ###
  silent: false

  ###*
    @type {?string}
    @protected
  ###
  currentHref: null

  ###*
    @param {string} token
    @param {boolean=} silent
  ###
  setToken: (token, @silent = false) ->
    # Token for html5 navigation has to be without '/', '#' prefixes.
    # Token for hash navigation has to be with '/' prefix, to make it look more
    # like a route and make sure it doesn't conflict with IDs on the page.
    token = este.string.stripSlashHashPrefixes token
    if !@html5historyEnabled
      token = '/' + token
    @history.setToken token

  ###*
    @param {string} token
    @param {boolean=} silent
  ###
  replaceToken: (token, @silent = false) ->
    token = este.string.stripSlashHashPrefixes token
    if !@html5historyEnabled
      token = '/' + token
    @history.replaceToken token

  ###*
    @return {string}
  ###
  getToken: ->
    @history.getToken()

  ###*
    It dispatches navigate event.
    @param {boolean=} enabled
  ###
  setEnabled: (enabled = true) ->
    if enabled
      @on @history, 'navigate', @onNavigate
    else
      @off @history, 'navigate', @onNavigate
    @history.setEnabled enabled

  ###*
    @param {string} pathPrefix
    @protected
  ###
  setHistoryInternal: (pathPrefix) ->
    if @html5historyEnabled
      transformer = new este.history.TokenTransformer()
      @history = new goog.history.Html5History undefined, transformer
      @history.setUseFragment false
      @history.setPathPrefix pathPrefix
    else
      # workaround: hidden input created in history via doc.write does not work
      input = goog.dom.createDom 'input', style: 'display: none'
      `input = /** @type {HTMLInputElement} */ (input)`
      document.body.appendChild input
      @history = new goog.History false, undefined, input

  ###*
    @param {goog.history.Event} e
    @protected
  ###
  onNavigate: (e) ->
    # fix for browsers which fires popstate event on page load (webkit)
    return if @currentHref == location.href
    @currentHref = location.href

    if @silent
      @silent = false
      return

    # because hash navigation needs '/' token prefix to render '#/' path prefix
    e.token = e.token.substring 1 if !@html5historyEnabled
    @dispatchEvent e

  ###*
    @override
  ###
  disposeInternal: ->
    @history.dispose()
    super
    return