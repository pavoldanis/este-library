###*
  @fileoverview Collection. Sorting & Filtering included.
  @see ../demos/collection.html
###

goog.provide 'este.Collection'

goog.require 'este.Base'
goog.require 'este.Model'
goog.require 'este.Model.Event'
goog.require 'goog.array'

class este.Collection extends este.Base

  ###*
    @param {Array.<Object>=} array
    @constructor
    @extends {este.Base}
  ###
  constructor: (array) ->
    super()
    @ids = {}
    @array = []
    @add array if array
    return

  ###*
    http://www.restapitutorial.com/lessons/restfulresourcenaming.html
    Url has to start with '/'. Function type is usefull for inheritance.
    If empty, model.url is used.
    @type {string|function(): string}
    @protected
  ###
  url: ''

  ###*
    @type {Object.<string, boolean>}
    @protected
  ###
  ids: null

  ###*
    @type {Array.<Object>}
    @protected
  ###
  array: null

  ###*
    @type {function(new:este.Model, Object=)}
    @protected
  ###
  model: este.Model

  ###*
    @type {Function}
    @protected
  ###
  sortBy: null

  ###*
    @type {Function}
    @protected
  ###
  sortCompare: goog.array.defaultCompare

  ###*
    @type {boolean}
    @protected
  ###
  sortReversed: false

  ###*
    @return {string}
  ###
  getUrl: ->
    url = @url || @model::url
    url = url() if goog.isFunction url
    url

  ###*
    @param {Array.<Object|este.Model>|Object|este.Model} arg
    @return {boolean} True if any element were added.
  ###
  add: (arg) ->
    array = if goog.isArray arg then arg else [arg]
    added = []
    for item in array
      item = new @model item if !(item instanceof @model)
      @ensureUnique item
      item.addParent @ if item instanceof este.Base
      added.push item
    return false if !added.length
    @array.push.apply @array, added
    @sortInternal()
    @dispatchAddEvent added
    true

  ###*
    @param {Array.<este.Model>|este.Model} arg
    @return {boolean} True if any element were removed.
  ###
  remove: (arg) ->
    array = if goog.isArray arg then arg else [arg]
    removed = []
    for item in array
      @removeUnique item
      item.removeParent @ if item instanceof este.Base
      removed.push item if goog.array.remove @array, item
    return false if !removed.length
    @dispatchRemoveEvent removed
    true

  ###*
    Replace whole collection.
    @param {Array.<Object|este.Model>|Object|este.Model} arg
    @return {boolean} True if any element were added.
  ###
  reset: (arg) ->
    @clear()
    @add arg

  ###*
    Clear collection.
  ###
  clear: ->
    @remove @array.slice 0

  ###*
    @param {Function} callback
  ###
  removeIf: (callback) ->
    toRemove = goog.array.filter @array, callback
    @remove toRemove

  ###*
    @param {este.Model} model
    @return {boolean}
  ###
  contains: (model) ->
    goog.array.contains @array, model

  ###*
    @param {number} index
    @return {este.Model}
  ###
  at: (index) ->
    model = @array[index]
    `/** @type {este.Model} */ (model)`

  ###*
    @return {number}
  ###
  getLength: ->
    @array.length

  ###*
    @return {Array.<este.Model>}
  ###
  toArray: ->
    @array

  ###*
    Serialize into JSON.
    @param {boolean=} raw If true, _cid, metas, and getters are ignored.
    @return {Array.<Object>}
  ###
  toJson: (raw) ->
    item.toJson raw for item in @array

  ###*
    Find item.
    @param {Function} fn
    @return {este.Model}
  ###
  find: (fn) ->
    model = goog.array.find @array, fn
    `/** @type {este.Model} */ (model)`

  ###*
    Find item by Id.
    @param {string|number} id
    @return {este.Model}
  ###
  findById: (id) ->
    @find (item) =>
      id.toString() == item.getId()

  ###*
    Find item by client id.
    @param {string|number} id
    @return {este.Model}
  ###
  findByClientId: (id) ->
    @find (item) =>
      id == item.get '_cid'

  ###*
    @param {{by: Function, compare: Function, reversed: boolean}=} options
  ###
  sort: (options) ->
    @sortBy = options.by if options?.by?
    @sortCompare = options.compare if options?.compare?
    @sortReversed = options.reversed if options?.reversed?
    @sortInternal()
    @dispatchSortEvent()
    return

  ###*
    @return {function(new:este.Model)}
  ###
  getModel: ->
    @model

  ###*
    Returns array of serialized models. Why array and not este.Collection?
    Because it would be costly. Every collection registers child model events.
    @param {Function|Object} filter
    @param {boolean=} raw
    @return {Array.<Object>}
  ###
  filter: (filter, raw = false) ->
    if typeof filter == 'function'
      filtered = []
      filtered.push item.toJson(raw) for item in @array when filter item
      return filtered

    @filter (item) ->
      for key, value of filter
        return false if item.get(key) != value
      true
    , raw

  ###*
    Calls a function for each element in an collection.
    @param {Function} fn
  ###
  each: (fn) ->
    goog.array.forEach @array, fn
    return

  ###*
    @param {Array} added
    @protected
  ###
  dispatchAddEvent: (added) ->
    addEvent = new este.Model.Event este.Model.EventType.ADD, @
    addEvent.added = added
    @dispatchCollectionEvent addEvent

  ###*
    @param {Array} removed
    @protected
  ###
  dispatchRemoveEvent: (removed) ->
    removeEvent = new este.Model.Event este.Model.EventType.REMOVE, @
    removeEvent.removed = removed
    @dispatchCollectionEvent removeEvent

  ###*
    @protected
  ###
  dispatchSortEvent: ->
    sortEvent = new este.Model.Event este.Model.EventType.SORT, @
    @dispatchCollectionEvent sortEvent

  ###*
    @param {este.Model.Event} e
    @protected
  ###
  dispatchCollectionEvent: (e) ->
    @dispatchEvent e
    updateEvent = new este.Model.Event este.Model.EventType.UPDATE, @
    updateEvent.origin = e
    @dispatchEvent updateEvent

  ###*
    @protected
  ###
  sortInternal: ->
    return if !@sortBy || !@sortCompare
    @array.sort (a, b) =>
      a = @sortBy a
      b = @sortBy b
      @sortCompare a, b
    @array.reverse() if @sortReversed
    return

  ###*
    Ensure only just one model in collection.
    @param {este.Model} model
    @protected
  ###
  ensureUnique: (model) ->
    id = model.getId() || model.get('_cid')
    if @ids['$' + id]
      goog.asserts.fail "Not allowed to add two models with the same id: #{id}"
    @ids['$' + id] = true

  ###*
    Remove unique id.
    @param {este.Model} model
    @protected
  ###
  removeUnique: (model) ->
    id = model.getId() || model.get('_cid')
    delete @ids['$' + id]

  ###*
    @override
  ###
  disposeInternal: ->
    @clear()
    super()
    return