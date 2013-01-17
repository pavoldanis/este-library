###*
  @fileoverview Style utils.
###

goog.provide 'este.style'

goog.require 'goog.style'
goog.require 'este.dom'
goog.require 'goog.editor.style'
goog.require 'goog.array'

goog.scope ->
  `var _ = este.style`

  ###*
    @param {Element} element
    @param {string} stylePropertyName
    @return {string}
  ###
  _.getComputedStyle = (element, stylePropertyName) ->
    `element = /** @type {Element} */ (element)`
    if goog.userAgent.IE
      goog.style.getCascadedStyle element, stylePropertyName
    else
      goog.style.getComputedStyle element, stylePropertyName

  ###*
    @param {Element} element
    @return {boolean}
  ###
  _.isVisible = (element) ->
    ancestors = este.dom.getAncestors element
    `var doc = /** @type {Document} */ (ancestors[ancestors.length - 1])`
    return false if doc != element.ownerDocument
    goog.array.every ancestors, (el) ->
      _.getComputedStyle(el, 'display') != 'none'

  return







