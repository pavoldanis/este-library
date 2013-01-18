###*
  @fileoverview este.demos.app.simple.products.Presenter.
###
goog.provide 'este.demos.app.simple.products.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.simple.products.Collection'
goog.require 'este.demos.app.simple.products.View'

class este.demos.app.simple.products.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    super()
    seedJsonData = [
      'name': 'Product A'
      'description': 'A description...'
    ,
      'name': 'Product B'
      'description': 'B description...'
    ,
      'name': 'Product C'
      'description': 'C description...'
    ]
    @products = new este.demos.app.simple.products.Collection seedJsonData
    @view = new este.demos.app.simple.products.View @products

  ###*
    @override
  ###
  load: (params) ->
    # async simulation
    result = new goog.result.SimpleResult
    setTimeout ->
      result.setValue null
    , 2000
    result

  ###*
    @override
  ###
  disposeInternal: ->
    super()
    @products.dispose()
    return
