###*
  @fileoverview goog.history.Html5History default behavior is that setToken
  replaces pathname of current location, but keeps search query as is.

  This transformer treats tokens as "pathAndAfter"; hence they may also include
  query string and a query string is replaced when a new history state is
  pushed.
###

goog.provide 'este.history.TokenTransformer'

goog.require 'goog.history.Html5History.TokenTransformer'

class este.history.TokenTransformer

  ###*
    @constructor
    @implements {goog.history.Html5History.TokenTransformer}
  ###
  constructor: ->

  ###*
    @override
  ###
  retrieveToken: (pathPrefix, location) ->
    (location.pathname.substr pathPrefix.length) + location.search

  ###*
    @override
  ###
  createUrl: (token, pathPrefix, location) ->
    pathPrefix + token