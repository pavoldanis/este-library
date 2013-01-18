###*
  @fileoverview goog.storage.Storage factory.
###
goog.provide 'este.storage.create'
goog.provide 'este.storage.createCollectable'

goog.require 'goog.storage.mechanism.mechanismfactory'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.CollectableStorage'

goog.scope ->
  `var _ = este.storage`

  ###*
    @param {string} key e.g. e-ui-formspersister
    @param {boolean=} session
    @return {goog.storage.Storage}
  ###
  _.create = (key, session = false) ->
    mechanism = _.getMechanism key, session
    return null if !mechanism
    new goog.storage.Storage mechanism

  ###*
    @param {string} key e.g. e-ui-formspersister
    @param {boolean=} session
    @return {goog.storage.CollectableStorage}
  ###
  _.createCollectable = (key, session = false) ->
    mechanism = _.getMechanism key, session
    return null if !mechanism
    storage = new goog.storage.CollectableStorage mechanism
    storage.collect true
    storage

  ###*
    @param {string} key e.g. e-ui-formspersister
    @param {boolean=} session
    @return {goog.storage.mechanism.IterableMechanism}
  ###
  _.getMechanism = (key, session) ->
    factory = goog.storage.mechanism.mechanismfactory
    mechanism = if session
      factory.createHTML5SessionStorage key
    else
      factory.create key

  return