###*
  @fileoverview este.ui.View.
###
goog.provide 'este.ui.View'

goog.require 'este.Collection'
goog.require 'este.Model'
goog.require 'este.ui.Component'

class este.ui.View extends este.ui.Component

  ###*
    @param {goog.dom.DomHelper=} domHelper Optional DOM helper.
    @constructor
    @extends {este.ui.Component}
  ###
  constructor: (domHelper) ->
    super domHelper

  ###*
    @param {Function} fn
    @return
  ###
  bindModel: (fn) ->
    (e) ->
      el = @getClientIdParent e.target
      model = @findModelByClientId el.getAttribute 'data-cid' if el
      fn.call @, model, el, e

  ###*
    @param {Element} el
    @return {Element}
    @protected
  ###
  getClientIdParent: (el) ->
    parent = goog.dom.getAncestor el, (node) ->
      goog.dom.isElement(node) && node.hasAttribute 'data-cid'
    , true
    `/** @type {Element} */ (parent)`

  ###*
    @param {string} clientId
    @return {este.Model}
    @protected
  ###
  findModelByClientId: (clientId) ->
    for key, value of @
      if value instanceof este.Collection
        model = value.findByClientId clientId
        return model if model
      else if value instanceof este.Model
        return value if value.get('_cid') == clientId
    null