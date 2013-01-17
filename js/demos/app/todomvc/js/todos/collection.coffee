###*
  @fileoverview Collection representing list of items.
###
goog.provide 'este.demos.app.todomvc.todos.Collection'

goog.require 'este.Collection'
goog.require 'este.demos.app.todomvc.todo.Model'

class este.demos.app.todomvc.todos.Collection extends este.Collection

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
  model: este.demos.app.todomvc.todo.Model

  ###*
    @param {boolean} completed
  ###
  toggleCompleted: (completed) ->
    @each (item) ->
      item.set 'completed', completed

  toggleAll: ->
    allCompleted = @allCompleted()
    @toggleCompleted !allCompleted

  clearCompleted: ->
    @removeIf (todo) ->
      todo.get 'completed'

  ###*
    @return {number}
  ###
  getRemainingCount: ->
    @filter('completed': false).length

  ###*
    @return {boolean}
  ###
  allCompleted: ->
    @getRemainingCount() == 0

  ###*
    @param {string} state
    @return {Object}
  ###
  filterByState: (state) ->
    switch state
      when 'active'
        @filter 'completed': false
      when 'completed'
        @filter 'completed': true
      else
        @toJson()