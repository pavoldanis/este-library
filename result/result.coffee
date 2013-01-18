###*
  @fileoverview Result utils.
###

goog.provide 'este.result'

goog.require 'goog.result'
goog.require 'goog.result.SimpleResult'

goog.scope ->
  `var _ = este.result`

  ###*
    @param {*=} value
    @return {!goog.result.Result}
  ###
  _.ok = (value = null) ->
    result = new goog.result.SimpleResult
    result.setValue value
    result

  ###*
    @return {!goog.result.Result}
  ###
  _.fail = ->
    result = new goog.result.SimpleResult
    result.setError()
    result

  return