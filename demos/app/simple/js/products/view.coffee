###*
  @fileoverview este.demos.app.simple.products.View.
###
goog.provide 'este.demos.app.simple.products.View'

goog.require 'este.app.View'
goog.require 'este.demos.app.simple.products.Collection'

class este.demos.app.simple.products.View extends este.app.View

  ###*
    @param {este.demos.app.simple.products.Collection} products
    @constructor
    @extends {este.app.View}
  ###
  constructor: (@products) ->
    super()

  ###*
    @type {este.demos.app.simple.products.Collection}
    @protected
  ###
  products: null

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @update()
    return

  ###*
    @protected
  ###
  update: ->
    window['console']['log'] "products rendered"
    links = []
    for product in @products.toJson()
      url = @createUrl este.demos.app.simple.product.Presenter,
        'id': product['_cid']
      links.push "<li><a href='#{url}'>#{product['name']}</a>"

    @getElement().innerHTML = """
      <p>List of products:</p>
      <ul>
        #{links.join ''}
      </ul>
    """