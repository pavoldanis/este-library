###*
  @fileoverview Local storage for este.Model's via HTML5 or IE user data.

  TODO:
    check goog.storage.mechanism.ErrorCode.QUOTA_EXCEEDED
    versions
    change scripts
###
goog.provide 'este.storage.Local'

goog.require 'este.json'
goog.require 'este.result'
goog.require 'este.storage.Base'
goog.require 'goog.object'
goog.require 'goog.storage.mechanism.mechanismfactory'
goog.require 'goog.string'
goog.require 'goog.uri.utils'

class este.storage.Local extends este.storage.Base

  ###*
    @param {string} namespace
    @param {string=} version
    @param {goog.storage.mechanism.Mechanism=} mechanism
    @param {function():string=} idFactory
    @constructor
    @extends {este.storage.Base}
  ###
  constructor: (namespace, version, mechanism, idFactory) ->
    super namespace, version
    @namespace = goog.uri.utils.appendPath @namespace, @version
    @mechanism = mechanism ?
      goog.storage.mechanism.mechanismfactory.create @namespace
    @idFactory = idFactory ?
      goog.string.getRandomString

  ###*
    @type {goog.storage.mechanism.Mechanism}
    @protected
  ###
  mechanism: null

  ###*
    @type {function():string}
    @protected
  ###
  idFactory: ->

  ###*
    @override
  ###
  addInternal: (model, url) ->
    @saveInternal model, url

  ###*
    @override
  ###
  loadInternal: (model, url) ->
    id = model.getId()
    models = @loadModels url
    return este.result.fail() if !models
    json = models[id]
    return este.result.fail() if !json
    model.set json
    este.result.ok id

  ###*
    @override
  ###
  saveInternal: (model, url) ->
    @ensureModelId model
    id = model.getId()
    serializedModels = @mechanism.get url
    models = if serializedModels then este.json.parse serializedModels else {}
    models[id] = model.toJson true
    @saveModels models, url
    este.result.ok id

  ###*
    @override
  ###
  removeInternal: (model, url) ->
    id = model.getId()
    if id
      models = @loadModels url
      if models && models[id]
        delete models[id]
        @saveModels models, url
        return este.result.ok id
    este.result.fail()

  ###*
    @override
  ###
  queryInternal: (collection, url, params) ->
    models = @loadModels url
    array = (model for id, model of models)
    collection.reset array
    este.result.ok params

  ###*
    @param {este.Model} model
    @protected
  ###
  ensureModelId: (model) ->
    id = model.getId()
    return if id
    model.setId @idFactory()

  ###*
    @param {Object.<string, Object>} models
    @param {string} url
    @protected
  ###
  saveModels: (models, url) ->
    if goog.object.isEmpty models
      @mechanism.remove url
    else
      serializedJson = este.json.stringify models
      @mechanism.set url, serializedJson

  ###*
    @param {string} url
    @return {Object.<string, Object>}
    @protected
  ###
  loadModels: (url) ->
    serializedJson = @mechanism.get url
    return null if !serializedJson
    este.json.parse serializedJson