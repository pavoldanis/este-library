suite 'este.storage.Local', ->

  Local = este.storage.Local
  Model = este.Model

  root = null
  mechanism = null
  idFactory = null
  model = null
  collection = null
  local = null

  setup ->
    root = ''

    mechanism =
      set: (key, value) ->
        @[key] = value
      get: (key) ->
        @[key]
      remove: (key) ->
        delete @[key]

    idFactory = -> 'someUniqueId'
    model = new Model

    collection =
      getModel: -> Model
      getUrl: -> 'Model::url'
      add: ->
      clear: ->
      reset: ->

    local = new Local root, '', mechanism, idFactory
    local.version = ''

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf local, Local

  suite 'save', ->
    test 'should assign id for model without id', ->
      local.save model
      assert.equal model.getId(), 'someUniqueId'

    test 'should store json to mechanism', (done) ->
      mechanism.set = (key, value) ->
        assert.equal key, '/models'
        assert.equal value, '{"someUniqueId":{"foo":"bla","id":"fok"}}'
        done()
      model.toJson = (raw) ->
        assert.isTrue raw
        foo: 'bla'
        id: 'fok'
      local.save model

    test 'should return success result with id', (done) ->
      result = local.save model
      goog.result.waitOnSuccess result, (value) ->
        assert.equal value, 'someUniqueId'
        done()

  suite 'load', ->
    test 'should mechanism.get model', (done) ->
      getKey = null
      mechanism.get = (key) ->
        assert.equal key, '/models'
        done()
      model.id = '123'
      local.load model

    test 'should load model', (done) ->
      mechanism.get = (key) ->
        assert.equal key, '/models'
        '{"123":{"foo":"bla"}}'
      model.id = '123'
      model.set = (json) ->
        assert.deepEqual json,
          foo: 'bla'
        done()
      local.load model

    test 'should return success result with id', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"}}'
      model.id = '123'
      result = local.load model
      goog.result.waitOnSuccess result, (value) ->
        assert.equal value, '123'
        done()

    test 'should return error result if storage does not exists', (done) ->
      mechanism.get = (key) -> ''
      model.id = '123'
      result = local.load model
      goog.result.waitOnError result, ->
        done()

    test 'should return error result if storage item does not exists', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"}}'
      model.id = '789'
      result = local.load model
      goog.result.waitOnError result, ->
        done()

  suite 'remove', ->
    test 'should remove model from storage', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"}}'
      mechanism.remove = (key) ->
        assert.equal key, '/models'
        done()
      model.id = '123'
      local.remove model

    test 'should return success result with id', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"}}'
      model.id = '123'
      result = local.remove model
      goog.result.waitOnSuccess result, (value) ->
        assert.equal value, '123'
        done()

    test 'should return error result if storage does not exists', (done) ->
      mechanism.get = (key) -> ''
      model.id = '456'
      result = local.remove model
      goog.result.waitOnError result, ->
        done()

    test 'should return error result if item does not exists', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"}}'
      model.id = '456'
      result = local.remove model
      goog.result.waitOnError result, ->
        done()

  suite 'query', ->
    test 'should load collection', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"},"456":{"bla":"foo"}}'
      collection.reset = (array) ->
        assert.deepEqual array, [
          foo: 'bla'
        ,
          bla: 'foo'
        ]
        done()
      local.query collection

    test 'should return success result with params', (done) ->
      mechanism.get = (key) -> '{"123":{"foo":"bla"},"456":{"bla":"foo"}}'
      params = {}
      result = local.query collection, params
      goog.result.waitOnSuccess result, (value) ->
        assert.equal value, params
        done()