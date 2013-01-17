###*
  @fileoverview este.app.request.Queue.
###
goog.provide 'este.app.request.Queue'

goog.require 'goog.array'
goog.require 'goog.Disposable'

class este.app.request.Queue extends goog.Disposable

  ###*
    @constructor
    @extends {goog.Disposable}
  ###
  constructor: ->
    @pending = []

  ###*
    @type {Array.<este.app.Request>}
    @protected
  ###
  pending: null

  ###*
    @param {este.app.Request} request
  ###
  add: (request) ->
    @pending.push request

  ###*
    @param {este.app.Request} request
    @return {boolean}
  ###
  dequeue: (request) ->
    return false if !@pending.length
    return false if !goog.array.peek(@pending).equal request
    @clear()
    true

  ###*
    @return {boolean}
  ###
  isEmpty: ->
    !@pending.length

  ###*
    Clear pending requests.
  ###
  clear: ->
    @pending.length = 0

  ###*
    @override
  ###
  disposeInternal: ->
    @clear()
    super()