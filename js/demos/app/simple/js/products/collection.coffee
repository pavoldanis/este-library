###*
  @fileoverview este.demos.app.simple.products.Collection.
###
goog.provide 'este.demos.app.simple.products.Collection'

goog.require 'este.Collection'
goog.require 'este.demos.app.simple.product.Model'

class este.demos.app.simple.products.Collection extends este.Collection

  ###*
    @param {Array=} array
    @constructor
    @extends {este.Collection}
  ###
  constructor: (array) ->
    super array

  ###*
    @override
  ###
  model: este.demos.app.simple.product.Model