###*
  @fileoverview este.demos.app.todomvc.todos.View.
###
goog.provide 'este.demos.app.todomvc.todos.View'

goog.require 'este.app.View'
goog.require 'este.demos.app.todomvc.todos.Collection'
goog.require 'este.demos.app.todomvc.todos.templates'
goog.require 'goog.i18n.pluralRules'

class este.demos.app.todomvc.todos.View extends este.app.View

  ###*
    @param {este.demos.app.todomvc.todos.Collection} todos
    @constructor
    @extends {este.app.View}
  ###
  constructor: (@todos) ->
    super()

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
    @override
  ###
  registerEvents: ->
    @on
      '#new-todo-form submit': @onNewTodoSubmit
      '#toggle-all tap': @onToggleAllTap
      '#clear-completed tap': @onClearCompletedTap
      '.toggle tap': @bindModel @onToggleTap
      '.destroy tap': @bindModel @onDestroyTap
      'label dblclick': @bindModel @onLabelDblclick
      '.edit blur': @bindModel @onEditEnd
      '.edit': [goog.events.KeyCodes.ENTER, @bindModel @onEditEnd]

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onNewTodoSubmit: (e) ->
    todo = new este.demos.app.todomvc.todo.Model e.json
    errors = todo.validate()
    return if errors
    e.target.elements['title'].value = ''
    @todos.add todo

  ###*
    @protected
  ###
  onToggleAllTap: ->
    @todos.toggleAll()

  ###*
    @protected
  ###
  onClearCompletedTap: ->
    @todos.clearCompleted()

  ###*
    @param {este.demos.app.todomvc.todo.Model} model
    @protected
  ###
  onToggleTap: (model) ->
    model.toggleCompleted()

  ###*
    @param {este.demos.app.todomvc.todo.Model} model
    @protected
  ###
  onDestroyTap: (model) ->
    @todos.remove model

  ###*
    @param {este.demos.app.todomvc.todo.Model} model
    @param {Element} el
    @protected
  ###
  onLabelDblclick: (model, el) ->
    model.set 'editing', true
    edit = el.querySelector '.edit'
    este.dom.focus edit

  ###*
    @param {este.demos.app.todomvc.todo.Model} model
    @param {Element} el
    @protected
  ###
  onEditEnd: (model, el) ->
    edit = el.querySelector '.edit'
    title = goog.string.trim edit.value
    if !title
      @todos.remove model
      return

    model.set
      'title': title
      'editing': false

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
    json = @getJsonForTemplate()
    html = este.demos.app.todomvc.todos.templates.element json
    este.dom.merge @getElement(), html

  ###*
    @return {Object}
    @protected
  ###
  getJsonForTemplate: ->
    length = @todos.getLength()
    remainingCount = @todos.getRemainingCount()

    doneCount: length - remainingCount
    filter: @filter
    itemsLocalized: @getLocalizedItems remainingCount
    remainingCount: remainingCount
    todos: @todos.filterByState @filter
    showMainAndFooter: !!length

  ###*
    estejs.tumblr.com/post/35639619128/este-js-localization-cheat-sheet
    @param {number} remainingCount
    @return {string}
    @protected
  ###
  getLocalizedItems: (remainingCount) ->
    switch goog.i18n.pluralRules.select remainingCount
      when goog.i18n.pluralRules.Keyword.ONE
        @MSG_ONE_ITEMLEFT
      when goog.i18n.pluralRules.Keyword.ZERO
        @MSG_ZERO_ITEMLEFT
      when goog.i18n.pluralRules.Keyword.TWO
        @MSG_TWO_ITEMLEFT
      when goog.i18n.pluralRules.Keyword.FEW
        @MSG_FEW_ITEMLEFT
      when goog.i18n.pluralRules.Keyword.MANY
        @MSG_MANY_ITEMLEFT
      else
        @MSG_OTHER_ITEMLEFT

  ###*
    @desc One item left.
    @protected
  ###
  MSG_ONE_ITEMLEFT: goog.getMsg 'item left'

  ###*
    @desc Zero items left.
    @protected
  ###
  MSG_ZERO_ITEMLEFT: goog.getMsg 'items left'

  ###*
    @desc Two items left.
    @protected
  ###
  MSG_TWO_ITEMLEFT: goog.getMsg 'items left'

  ###*
    @desc Few items left.
    @protected
  ###
  MSG_FEW_ITEMLEFT: goog.getMsg 'items left'

  ###*
    @desc Many items left.
    @protected
  ###
  MSG_MANY_ITEMLEFT: goog.getMsg 'items left'

  ###*
    @desc Other items left.
    @protected
  ###
  MSG_OTHER_ITEMLEFT: goog.getMsg 'items left'