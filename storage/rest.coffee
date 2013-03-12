###*
  @fileoverview Rest JSON storage.
  @see ../demos/storage/rest.html
###
goog.provide 'este.storage.Rest'

goog.require 'este.json'
goog.require 'este.storage.Base'
goog.require 'goog.labs.net.xhr'
goog.require 'goog.object'
goog.require 'goog.string'
goog.require 'goog.uri.utils'

class este.storage.Rest extends este.storage.Base

  ###*
    @param {string} namespace
    @param {string=} version
    @param {Object=} queryParams
    @constructor
    @extends {este.storage.Base}
  ###
  constructor: (namespace, version, queryParams) ->
    super namespace, version
    @namespace = namespace.replace ':version', @version
    @queryParams = queryParams ? null
    `this.xhrOptions = /** @type {goog.labs.net.xhr.Options} */ (this.xhrOptions)`

  ###*
    @type {Object}
    @protected
  ###
  queryParams: null

  ###*
    @protected
  ###
  xhrOptions:
    headers:
      'Content-Type': 'application/json;charset=utf-8'

  ###*
    @param {string} url
    @param {string=} id
    @protected
  ###
  getRestUrl: (url, id) ->
    restUrl = goog.uri.utils.appendPath @namespace, url
    if id
      restUrl = goog.uri.utils.appendPath restUrl, id
    if @queryParams
      restUrl = goog.uri.utils.appendParamsFromMap restUrl, @queryParams
    restUrl

  ###*
    @override
  ###
  addInternal: (model, url) ->
    restUrl = @getRestUrl url
    data = model.toJson true
    data = este.json.stringify data
    result = goog.labs.net.xhr.postJson restUrl, data, @xhrOptions
    goog.result.waitOnSuccess result, (json) ->
      model.set json
    result

  ###*
    @override
  ###
  loadInternal: (model, url) ->
    id = model.getId()
    restUrl = @getRestUrl url, id
    result = goog.labs.net.xhr.getJson restUrl, @xhrOptions
    goog.result.waitOnSuccess result, (json) ->
      model.set json
    result

  ###*
    @override
  ###
  saveInternal: (model, url) ->
    id = model.getId()
    restUrl = @getRestUrl url, id
    data = model.toJson true
    data = este.json.stringify data
    goog.labs.net.xhr.send 'PUT', restUrl, data, @xhrOptions

  ###*
    @override
  ###
  removeInternal: (model, url) ->
    id = model.getId()
    restUrl = @getRestUrl url, id
    goog.labs.net.xhr.send 'DELETE', restUrl, null, @xhrOptions

  ###*
    @override
  ###
  queryInternal: (collection, url, params) ->
    restUrl = @getRestUrl url
    result = goog.labs.net.xhr.getJson restUrl, @xhrOptions
    goog.result.waitOnSuccess result, (array) ->
      collection.reset array
    result