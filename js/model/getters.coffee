###*
  @fileoverview Getters for este.Model
###

goog.provide 'este.model.getters'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.model.getters`

  ###*
    @param {string} value
    @return {number}
  ###
  _.parseInt = (value) ->
    parseInt value, 10

  return