###*
  @fileoverview este.app.Request.
###
goog.provide 'este.app.Request'

goog.require 'este.json'

class este.app.Request

  ###*
    @param {este.app.Presenter} presenter
    @param {Object=} params
    @param {boolean=} isNavigation True if request is dispatched as result of
        back forward browser button. If so, the url is yet changed.
    @constructor
  ###
  constructor: (@presenter, @params = null, @isNavigation = false) ->

  ###*
    @type {este.app.Presenter}
  ###
  presenter: null

  ###*
    @type {Object}
  ###
  params: null

  ###*
    @type {boolean}
  ###
  isNavigation: false

  ###*
    @param {este.app.Request} req
  ###
  equal: (req) ->
    @presenter == req.presenter && este.json.equal @params, req.params