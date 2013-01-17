###*
  @fileoverview Chunked JSONP implementation. Payload is divided into max. 2kb
  chunks.
###

goog.provide 'este.net.ChunkedJsonp'
goog.provide 'este.net.ChunkedJsonp.create'

goog.require 'goog.net.Jsonp'
goog.require 'este.string'
goog.require 'este.json'

class este.net.ChunkedJsonp

  ###*
    @param {Function} jsonpFactory
    @param {Function} randomStringFactory
    @constructor
  ###
  constructor: (@jsonpFactory, @randomStringFactory) ->

  ###*
    @param {goog.Uri|string} uri The Uri of the server side code that receives
    data posted through this channel (e.g., "http://maps.google.com/maps/geo").
    @param {string=} opt_callbackParamName The parameter name that is used to
    specify the callback. Defaults to "callback".
  ###
  @create: (uri, opt_callbackParamName) ->
    jsonpFactory = ->
      new goog.net.Jsonp uri, opt_callbackParamName
    new ChunkedJsonp jsonpFactory, goog.string.getRandomString

  ###*
    @type {number} http://support.microsoft.com/kb/208427
  ###
  @MAX_CHUNK_SIZE: 1900

  ###*
    @type {Function}
    @protected
  ###
  jsonpFactory: null

  ###*
    @type {Function}
    @protected
  ###
  randomStringFactory: null

  ###*
    @param {Object} payload
    @param {Function=} opt_replyCallback
  ###
  send: (payload, opt_replyCallback) ->
    chunks = @getChunks payload
    randomString = @randomStringFactory()
    callCount = 0

    jsonpReplyCallback = ->
      callCount++
      if callCount == chunks.length
        opt_replyCallback.apply null, arguments

    for chunk in chunks
      jsonp = @jsonpFactory()
      jsonpPayload =
        'u': randomString
        'd': chunk.text
        'i': chunk.index
        't': chunk.total
      if opt_replyCallback
        jsonp.send jsonpPayload, jsonpReplyCallback
      else
        jsonp.send jsonpPayload
    return

  ###*
    @param {Object} payload
    @return {Array.<Object>}
    @protected
  ###
  getChunks: (payload) ->
    str = este.json.stringify payload
    este.string.chunkToObject str, ChunkedJsonp.MAX_CHUNK_SIZE