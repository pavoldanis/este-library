###*
  @fileoverview este.demos.app.simple.product.View.
###
goog.provide 'este.demos.app.simple.product.View'

goog.require 'este.app.View'

class este.demos.app.simple.product.View extends este.app.View

  ###*
    @constructor
    @extends {este.app.View}
  ###
  constructor: ->
    super()

  ###*
    @type {Object}
    @protected
  ###
  params: null

  ###*
    @override
  ###
  registerEvents: ->
    @on
      'button click': @onButtonClick

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
    window['console']['log'] "product with id #{@params['id']} rendered"
    @getElement().innerHTML = """
      <p>Product detail:</p>
      <p>product with id #{@params['id']} rendered</p>
      <button>show products</button>
    """

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onButtonClick: (e) ->
    # explicit redirection example
    @redirect este.demos.app.simple.products.Presenter