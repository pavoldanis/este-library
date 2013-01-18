###*
  @fileoverview Forms persister. Persist form fields state into localStorage
  or session.

  note
    not tested in IE, but it should work in IE>8 and be easily fixable for rest

  TODO:
    add expiration
    improve field dom path (consider: url, form name, etc.)
    check&fix IE (http://stackoverflow.com/a/266252/233902)
  @see ../demos/formspersister.html
###

goog.provide 'este.ui.FormsPersister'
goog.provide 'este.ui.FormsPersister.create'

goog.require 'este.ui.Component'
goog.require 'goog.dom.forms'
goog.require 'este.dom'
goog.require 'goog.events.FocusHandler'
goog.require 'goog.events.InputHandler'
goog.require 'este.storage.create'

class este.ui.FormsPersister extends este.ui.Component

  ###*
    @param {boolean=} session
    @constructor
    @extends {este.ui.Component}
  ###
  constructor: (session = false) ->
    super()
    @storage = este.storage.createCollectable 'e-ui-formspersister', session

  ###*
    @param {Element} element
    @param {boolean=} session
    @return {este.ui.FormsPersister}
  ###
  @create: (element, session) ->
    persist = new este.ui.FormsPersister session
    persist.decorate element
    persist

  ###*
    Minimal client storage ftw.
    @type {number}
  ###
  expirationTime: 1000 * 60 * 60 * 24 * 30

  ###*
    @type {goog.storage.CollectableStorage}
    @protected
  ###
  storage: null

  ###*
    @type {goog.events.FocusHandler}
    @protected
  ###
  focusHandler: null

  ###*
    @override
  ###
  decorateInternal: (element) ->
    super element
    path = @getElementDomPath()
    data = @storage.get path.join()
    return if !data
    `data = /** @type {Object} */ (data)`
    @retrieve data
    return

  ###*
    @param {Object} data
    @protected
  ###
  retrieve: (data) ->
    for formPath, fields of data
      form = este.dom.getElementByDomPathIndex formPath.split ','
      continue if !form || !form.elements

      fieldsMap = {}
      for el in form.elements
        fieldsMap[el.name] ?= []
        fieldsMap[el.name].push el

      for name, value of fields
        field = fieldsMap[name]?[0]
        continue if !field

        switch field.type
          when 'radio'
            for el in fieldsMap[name]
              goog.dom.forms.setValue el, el.value == value
          when 'checkbox'
            for el in fieldsMap[name]
              goog.dom.forms.setValue el, goog.array.contains value, el.value
          else
            goog.dom.forms.setValue field, value
    return

  ###*
    @override
  ###
  enterDocument: ->
    super()
    @focusHandler = new goog.events.FocusHandler @getElement()
    @on @focusHandler, 'focusin', @onFocusin
    @on @getElement(), 'change', @onChange
    return

  ###*
    @override
  ###
  exitDocument: ->
    @focusHandler.dispose()
    super()
    return

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onFocusin: (e) ->
    `var target = /** @type {Element} */ (e.target)`
    return if !(target.tagName in ['INPUT', 'TEXTAREA'])
    @registerInputHander target

  ###*
    @param {Element} field
    @protected
  ###
  registerInputHander: (field) ->
    handler = new goog.events.InputHandler field
    @on handler, 'input', @onFieldInput
    @getHandler().listenOnce field, 'blur', (e) ->
      handler.dispose()

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onFieldInput: (e) ->
    `var target = /** @type {Element} */ (e.target)`
    @storeField target

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  onChange: (e) ->
    `var target = /** @type {Element} */ (e.target)`
    @storeField target

  ###*
    @param {Element} field
    @protected
  ###
  storeField: (field) ->
    formDomPath = este.dom.getDomPathIndexes field.form
    name = field.name
    value = @getFieldValue field
    @store formDomPath, name, value

  ###*
    @param {Array.<number>} formDomPath
    @param {string} name
    @param {string|Array.<string>} value
  ###
  store: (formDomPath, name, value) ->
    path = @getElementDomPath()
    key = path.join()
    storage = @storage.get key
    storage ?= {}
    storage[formDomPath] ?= {}
    storage[formDomPath][name] = value
    @storage.set key, storage, goog.now() + @expirationTime

  ###*
    @return {Array.<number>}
    @protected
  ###
  getElementDomPath: ->
    este.dom.getDomPathIndexes @getElement()

  ###*
    @param {Element} field
    @return {string|Array.<string>}
    @protected
  ###
  getFieldValue: (field) ->
    if field.type == 'checkbox'
      values = []
      for el in field.form.elements when el.name == field.name
        value = goog.dom.forms.getValue el
        values.push value if value?
      return values
    goog.dom.forms.getValue field