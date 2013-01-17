###*
  @fileoverview Model representing one todo item.
###
goog.provide 'este.demos.app.todomvc.todo.Model'

goog.require 'este.Model'

class este.demos.app.todomvc.todo.Model extends este.Model

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
  url: '/todos'

  ###*
    @override
  ###
  defaults:
    'title': ''
    'completed': false
    'editing': false

  ###*
    @override
  ###
  schema:
    'title':
      'set': este.model.setters.trim
      'validators':
        'required': este.model.validators.required

  toggleCompleted: ->
    @set 'completed', !@get 'completed'