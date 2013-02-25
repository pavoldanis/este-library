###*
  @fileoverview este.demos.app.simple.product.Model.
###
goog.provide 'este.demos.app.simple.product.Model'

goog.require 'este.Model'

class este.demos.app.simple.product.Model extends este.Model

  ###*
    @param {Object=} json
    @constructor
    @extends {este.Model}
  ###
  constructor: (json) ->
    super json

  ###*
    @override
  ###
  schema:
    'name':
      'set': este.model.setters.trim
      'validators': [
        este.validators.required()
      ]
    'description':
      'set': este.model.setters.trim
      'validators': [
        este.validators.required()
      ]