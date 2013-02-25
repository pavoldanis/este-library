###*
  @fileoverview este.Router.
  @see ../demos/routerhash.html
  @see ../demos/routerhtml5.html

  Navigation element is any element with 'href' attribute. Not only anchor, but
  li or tr too. Of course only <a href='..'s are crawable with search engines.
  But if we are creating pure client side rendered web app, we can use 'href'
  attribute on any element we need. We can even nest anchors, which is useful
  for touch devices.
###
goog.provide 'este.Router'

goog.require 'este.array'
goog.require 'este.Base'
goog.require 'este.dom'
goog.require 'este.router.Route'
goog.require 'este.string'

class este.Router extends este.Base

  ###*
    @param {este.History} history
    @param {este.events.TapHandler} tapHandler
    @constructor
    @extends {este.Base}
  ###
  constructor: (@history, @tapHandler) ->
    super
    @routes = []

  ###*
    If true, tapHandler will not change url.
    @type {boolean}
  ###
  silentTapHandler: false

  ###*
    @type {este.History}
    @protected
  ###
  history: null

  ###*
    @type {este.events.TapHandler}
    @protected
  ###
  tapHandler: null

  ###*
    @type {Array.<este.router.Route>}
    @protected
  ###
  routes: null

  ###*
    @type {boolean}
    @protected
  ###
  ignoreNextOnHistoryNavigate: false

  ###*
    @param {string} path
    @param {Function} show
    @param {este.router.Route.Options=} options
    @return {este.Router}
  ###
  add: (path, show, options = {}) ->
    path = este.string.stripSlashHashPrefixes path
    route = new este.router.Route path, show, options
    @routes.push route
    @

  ###*
    @param {string} path
    @return {boolean}
  ###
  remove: (path) ->
    path = este.string.stripSlashHashPrefixes path
    este.array.removeAllIf @routes, (item) ->
      item.path == path

  ###*
    @param {string} path
    @param {Object=} params
    @param {boolean=} silent
  ###
  pathNavigate: (path, params, silent = false) ->
    path = este.string.stripSlashHashPrefixes path
    route = @findRoute path
    return if !route
    @ignoreNextOnHistoryNavigate = silent
    @navigate route.createUrl params

  ###*
    @param {string} path
    @protected
  ###
  findRoute: (path) ->
    path = este.string.stripSlashHashPrefixes path
    goog.array.find @routes, (item) ->
      item.path == path

  ###*
    @param {string} token
  ###
  navigate: (token) ->
    token = este.string.stripSlashHashPrefixes token
    @history.setToken token

  ###*
    @return {boolean}
  ###
  isHtml5historyEnabled: ->
    @history.html5historyEnabled

  ###*
    Start router.
  ###
  start: ->
    @on @tapHandler.getElement(), 'click', @onTapHandlerElementClick
    @on @tapHandler, 'tap', @onTapHandlerTap
    @on @history, 'navigate', @onHistoryNavigate
    @history.setEnabled true
    return

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTapHandlerElementClick: (e) ->
    token = @tryGetToken e.target
    return if !token || !este.dom.isRealMouseClick e
    e.preventDefault()

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onTapHandlerTap: (e) ->
    token = @tryGetToken e.target
    return if !token
    return if e.clickEvent && !este.dom.isRealMouseClick e.clickEvent
    if @silentTapHandler
      @processRoutes token, false
      return
    strippedToken = este.string.stripSlashHashPrefixes token
    @history.setToken strippedToken

  ###*
    @param {goog.history.Event} e
    @protected
  ###
  onHistoryNavigate: (e) ->
    if @ignoreNextOnHistoryNavigate
      @ignoreNextOnHistoryNavigate = false
      return
    @processRoutes e.token, e.isNavigation

  ###*
    @param {Node} target
    @return {string}
    @protected
  ###
  tryGetToken: (target) ->
    token = ''
    goog.dom.getAncestor target, (node) ->
      return false if node.nodeType != 1
      return false if node.hasAttribute && node.hasAttribute 'e-ignore'
      return false if node.getAttribute('href')?.indexOf('http') == 0
      token = goog.string.trim node.getAttribute('href') || ''
      !!token
    , true
    token

  ###*
    @param {string} token
    @param {boolean} isNavigation
    @protected
  ###
  processRoutes: (token, isNavigation) ->
    token = este.string.stripSlashHashPrefixes token
    firstRouteMatched = false
    for route in @routes
      try
        matched = route.process token, isNavigation, firstRouteMatched
        firstRouteMatched = true if matched
      finally
        continue
    return

  ###*
    @override
  ###
  disposeInternal: ->
    @history.dispose()
    @tapHandler.dispose()
    super
    return