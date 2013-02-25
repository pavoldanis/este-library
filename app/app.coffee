###*
  @fileoverview este.App.
  @see ../demos/app/layout/index.html
  @see ../demos/app/simple/index.html
  @see ../demos/app/todomvc/index.html
###
goog.provide 'este.App'
goog.provide 'este.App.EventType'

goog.require 'este.app.Event'
goog.require 'este.app.renderLinks'
goog.require 'este.app.Request'
goog.require 'este.app.request.Queue'
goog.require 'este.app.Route'
goog.require 'este.Base'
goog.require 'este.result'
goog.require 'este.router.Route'

class este.App extends este.Base

  ###*
    @param {este.Router=} router
    @constructor
    @extends {este.Base}
  ###
  constructor: (@router = null) ->
    super()
    @queue = new este.app.request.Queue
    @routesInternal = []

  ###*
    @enum {string}
  ###
  @EventType:
    LOAD: 'load'
    SHOW: 'show'
    HIDE: 'hide'

  ###*
    @type {boolean}
  ###
  urlProjectionEnabled: true

  ###*
    @type {Array.<este.app.Route>}
  ###
  routes: null

  ###*
    @type {este.storage.Base}
  ###
  storage: null

  ###*
    @type {este.app.screen.Base}
  ###
  screen: null

  ###*
    @type {este.app.request.Queue}
    @protected
  ###
  queue: null

  ###*
    @type {este.Router}
    @protected
  ###
  router: null

  ###*
    @type {este.app.Request}
    @protected
  ###
  lastSuccessRequest: null

  ###*
    First location update has to be ignored, because it's caused by router
    start method, therefore there is no need to update location. If updated,
    it confuse este.History.
    @type {boolean}
    @protected
  ###
  locationUpdated: false

  ###*
    @type {Array.<este.app.Route>}
    @protected
  ###
  routesInternal: null

  ###*
    Starts router.
  ###
  start: ->
    goog.asserts.assert @routes && @routes.length,
      'At least one route has to be defined.'
    if !@urlProjectionEnabled
      @load @routes[0].presenter
      return

    @addRoute route for route in @routes
    @startRouter()

  ###*
    @param {este.app.Route} route
  ###
  addRoute: (route) ->
    @routesInternal.push route
    @preparePresenter route.presenter
    return if !route.path
    @router.add route.path, goog.bind @onRouteMatch, @, route.presenter

  ###*
    @param {function(new:este.app.Presenter)} presenterClass
    @param {Object=} params
    @return {string}
  ###
  createUrl: (presenterClass, params) ->
    route = @findRouteByPresenterClass presenterClass
    url = este.router.Route.createUrl route.path, params
    return url if @router.isHtml5historyEnabled()
    '#' + url

  ###*
    @param {function(new:este.app.Presenter)} presenterClass
    @param {Object=} params
    @return {string}
  ###
  redirect: (presenterClass, params) ->
    route = @findRouteByPresenterClass presenterClass
    @load route.presenter, params

  ###*
    @param {este.app.Presenter} presenter
    @return {este.app.Route}
    @protected
  ###
  findRouteByPresenter: (presenter) ->
    goog.array.find @routes, (route) ->
      route.presenter == presenter

  ###*
    @param {function(new:este.app.Presenter)} presenterClass
    @return {este.app.Route}
  ###
  findRouteByPresenterClass: (presenterClass) ->
    goog.array.find @routes, (route) ->
      route.presenter instanceof presenterClass

  ###*
    @param {este.app.Presenter} presenter
    @protected
  ###
  preparePresenter: (presenter) ->
    presenter.storage ?= @storage
    presenter.screen ?= @screen
    presenter.createUrl ?= goog.bind @createUrl, @
    presenter.redirect ?= goog.bind @redirect, @

  ###*
    @param {este.app.Presenter} presenter
    @param {Object=} params
    @param {boolean=} isNavigation
    @protected
  ###
  onRouteMatch: (presenter, params, isNavigation) ->
    @load presenter, params, isNavigation

  ###*
    @protected
  ###
  startRouter: ->
    @router.silentTapHandler = true
    @router.start()

  ###*
    @param {este.app.Presenter} presenter
    @param {Object=} params
    @param {boolean=} isNavigation
    @protected
  ###
  load: (presenter, params, isNavigation) ->
    request = new este.app.Request presenter, params, isNavigation
    @dispatchAppEvent App.EventType.LOAD, request
    result = presenter.load params
    @queue.add request
    goog.result.waitOnSuccess result, goog.bind @onLoad, @, request

  ###*
    @param {este.app.Request} request
    @protected
  ###
  onLoad: (request) ->
    return if !@queue.dequeue request
    @hidePreviousIfAny request
    @dispatchAppEvent App.EventType.SHOW, request
    request.presenter.show()
    @updateLocation request

  ###*
    @param {este.app.Request} request
    @protected
  ###
  hidePreviousIfAny: (request) ->
    if @lastSuccessRequest
      @dispatchAppEvent App.EventType.HIDE, @lastSuccessRequest
      @lastSuccessRequest.presenter.hide()
    @lastSuccessRequest = request

  ###*
    @param {este.app.Request} request
    @protected
  ###
  updateLocation: (request) ->
    if !@locationUpdated
      @locationUpdated = true
      return

    return if !@urlProjectionEnabled || request.isNavigation
    route = @findRouteByPresenter request.presenter
    path = route.path
    @router.pathNavigate path, request.params, true if path

  ###*
    @param {este.App.EventType} type
    @param {este.app.Request} request
    @protected
  ###
  dispatchAppEvent: (type, request) ->
    event = new este.app.Event type, request
    @dispatchEvent event

  ###*
    @override
  ###
  disposeInternal: ->
    @router.dispose()
    @queue.dispose()
    route.presenter.dispose() for route in @routesInternal
    super()
    return