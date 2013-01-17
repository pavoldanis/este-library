###*
  @fileoverview este.demos.app.todomvc.todos.Presenter.
###
goog.provide 'este.demos.app.todomvc.todos.Presenter'

goog.require 'este.app.Presenter'
goog.require 'este.demos.app.todomvc.todos.Collection'
goog.require 'este.demos.app.todomvc.todos.View'

class este.demos.app.todomvc.todos.Presenter extends este.app.Presenter

  ###*
    @constructor
    @extends {este.app.Presenter}
  ###
  constructor: ->
    super()
    # this collection is used for presenter data loading
    @todos = new este.demos.app.todomvc.todos.Collection
    # this collection is used for view data projection and manipulation
    @viewTodos = new este.demos.app.todomvc.todos.Collection
    @view = new este.demos.app.todomvc.todos.View @viewTodos

  ###*
    @type {este.demos.app.todomvc.todos.Collection}
    @protected
  ###
  todos: null

  ###*
    @type {string}
    @protected
  ###
  filter: ''

  ###*
    @type {?number}
    @private
  ###
  viewUpdateTimer: null

  ###*
    @override
  ###
  load: (params) ->
    @filter = params['filter'] || ''
    @storage.query @todos

  ###*
    @override
  ###
  show: ->
    @view.filter = @filter
    @viewTodos.reset @todos.toJson true
    super()
    @on @viewTodos, 'update', @onTodosUpdate

  ###*
    @override
  ###
  hide: ->
    super()
    @off @viewTodos, 'update', @onTodosUpdate

  ###*
    @param {este.Model.Event} e
    @protected
  ###
  onTodosUpdate: (e) ->
    result = @storage.saveChangesFromEvent e
    return if !result
    goog.result.waitOnSuccess result, @onSuccessTodosUpdate, @

  ###*
    @protected
  ###
  onSuccessTodosUpdate: ->
    clearTimeout @viewUpdateTimer
    @viewUpdateTimer = setTimeout =>
      @view.update()
    , 0