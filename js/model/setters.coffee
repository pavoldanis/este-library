###*
  @fileoverview Setters for este.Model
###

goog.provide 'este.model.setters'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.model.setters`

  ###*
    @param {string} value
    @return {string}
  ###
  _.trim = (value) ->
    goog.string.trim value

  return