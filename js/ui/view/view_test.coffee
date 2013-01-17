suite 'este.ui.View', ->

  View = este.ui.View

  view = null

  setup ->
    view = new View

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf view, View

  suite 'bindModel', ->
    suite 'on view with collection', ->
      test 'should work', (done) ->
        view.collection = new este.Collection
        view.collection.findByClientId = -> 'foo'
        original = (model, el, e) ->
          assert.equal model, 'foo'
          assert.equal el, target
          assert.equal e, event
          done()
        wrapped = view.bindModel original
        target =
          nodeType: 1
          attributes: 'data-cid': '123'
          hasAttribute: (name) -> name of @attributes
          getAttribute: (name) -> @attributes[name]
        event = target: target
        wrapped.call view, event

    suite 'on view with model', ->
      test 'should work', (done) ->
        view.model = new este.Model
        view.model.get = (attr) ->
          return '123' if attr == '_cid'
        original = (model, el, e) ->
          assert.equal model, view.model
          assert.equal el, target
          assert.equal e, event
          done()
        wrapped = view.bindModel original
        target =
          nodeType: 1
          attributes: 'data-cid': '123'
          hasAttribute: (name) -> name of @attributes
          getAttribute: (name) -> @attributes[name]
        event = target: target
        wrapped.call view, event