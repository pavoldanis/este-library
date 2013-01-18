###*
  @fileoverview Validators for este.Model
###

goog.provide 'este.model.validators'

goog.require 'goog.string'

goog.scope ->
  `var _ = este.model.validators`

  ###*
    @param {string} value
    @return {boolean}
  ###
  _.required = (value) ->
    !!(value && goog.string.trim(value).length)
  
  return