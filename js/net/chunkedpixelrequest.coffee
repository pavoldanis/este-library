###*
  @fileoverview Chunked pixel request. Payload is divided into max. 2kb
  chunks.
###

goog.provide 'este.net.ChunkedPixelRequest'
goog.provide 'este.net.ChunkedPixelRequest.create'

goog.require 'este.string'
goog.require 'este.json'

class este.net.ChunkedPixelRequest

  ###*
    @param {string} uri
    @param {Function} randomStringFactory
    @param {Function} srcCallback
    @constructor
  ###
  constructor: (@uri, @randomStringFactory, @srcCallback) ->

  ###*
    @param {string} uri
    @return {este.net.ChunkedPixelRequest}
  ###
  @create: (uri) ->
    srcCallback = (src) ->
      # new Image 1, 1 because that's how GA does it.
      img = new Image 1, 1
      img.src = src
      return
    new ChunkedPixelRequest uri, goog.string.getRandomString, srcCallback

  ###*
    @type {number} http://support.microsoft.com/kb/208427
  ###
  @MAX_CHUNK_SIZE: 1900

  ###*
    @type {string}
  ###
  uri: ''

  ###*
    @type {Function}
  ###
  randomStringFactory: null

  ###*
    @type {Function}
  ###
  srcCallback: null

  ###*
    @param {Object} payload
  ###
  send: (payload) ->
    chunks = @getChunks payload
    randomString = @randomStringFactory()
    for chunk in chunks
      message =
        'u': randomString
        'd': chunk.text
        'i': chunk.index
        't': chunk.total
      stringified = este.json.stringify message
      @srcCallback @uri + '?' + encodeURIComponent stringified
    return

  ###*
    @param {Object} payload
    @return {Array.<Object>}
    @protected
  ###
  getChunks: (payload) ->
    str = este.json.stringify payload
    este.string.chunkToObject str, ChunkedPixelRequest.MAX_CHUNK_SIZE