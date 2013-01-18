suite 'este.Collection', ->

  Collection = este.Collection
  Model = este.Model

  Child = null
  ChildCollection = null
  collection = null
  model = null

  setup ->
    arrangeChildAndItsCollection()
    collection = new Collection
    model = new Model

  arrangeChildAndItsCollection = ->
    Child = -> Model.apply @, arguments
    goog.inherits Child, Model
    Child::schema = c: meta: -> 'fok'
    ChildCollection = -> Collection.apply @, arguments
    goog.inherits ChildCollection, Collection
    ChildCollection::model = Child

  arrangeCollectionWithItems = ->
    collection.add 'a': 1, 'aa': 1.5
    collection.add 'b': 2, 'bb': 2.5
    collection.add 'c': 3, 'cc': 3.5

  suite 'constructor', ->
    test 'should allow inject json data', ->
      json = [
        a: 1
      ,
        b: 2
      ]
      collection = new Collection json
      assert.deepEqual collection.toJson(true), json

  suite 'model property', ->
    test 'should wrap json (meta test included)', ->
      json = [
        a: 1
      ,
        b: 2
      ]
      collection = new ChildCollection json
      assert.instanceOf collection.at(0), Child
      assert.equal collection.at(0).get('a'), 1
      assert.equal collection.at(1).get('b'), 2
      assert.equal collection.at(0).get('c'), 'fok'

    test 'should dispatch add event', (done) ->
      collection = new Collection
      goog.events.listen collection, 'add', (e) ->
        assert.instanceOf e.added[0], Model
        done()
      collection.add a: 1

    test 'toJson should serialize raw model', ->
      json = [
        id: 0
        a: 'aa'
      ,
        id: 1
        b: 'bb'
      ]
      collection = new ChildCollection json
      collectionJson = collection.toJson true
      assert.deepEqual collectionJson, [
        id: 0
        a: 'aa'
      ,
        id: 1
        b: 'bb'
      ]

  suite 'add, remove and getLength', ->
    test 'should work', ->
      assert.equal collection.getLength(), 0
      collection.add model
      assert.equal collection.getLength(), 1
      assert.isFalse collection.remove(new Model),
        'should not remove not existing model'
      assert.isTrue collection.remove model
      assert.equal collection.getLength(), 0

  suite 'add item', ->
    test 'should fire add event', ->
      addCalled = false
      added = null
      goog.events.listen collection, 'add', (e) ->
        added = e.added
        addCalled = true
      collection.add model
      assert.isTrue addCalled
      assert.deepEqual added, [model]

    test 'should fire update event', (done) ->
      goog.events.listen collection, 'update', (e) ->
        done()
      collection.add model

    test 'should throw exception for model item with same id', ->
      called = false
      collection = new ChildCollection
      collection.add id: 1
      try
        collection.add id: 1
      catch e
        called = true
      assert.isTrue called

    test 'should not throw exception for model item with same id if item was removed', ->
      called = false
      collection = new ChildCollection
      collection.add id: 1
      collection.remove collection.at 0
      try
        collection.add id: 1
      catch e
        called = true
      assert.isFalse called

  suite 'add items', ->
    test 'should fire add event', ->
      addCalled = false
      added = null
      goog.events.listen collection, 'add', (e) ->
        added = e.added
        addCalled = true
      collection.add [model]
      assert.isTrue addCalled
      assert.deepEqual added, [model]

  suite 'remove item', ->
    test 'should fire remove event', ->
      removeCalled = false
      removed = null
      collection.add model
      goog.events.listen collection, 'remove', (e) ->
        removed = e.removed
        removeCalled = true
      collection.remove model
      assert.isTrue removeCalled, 'removeCalled'
      assert.deepEqual removed, [model]

    test 'should fire update event', (done) ->
      collection.add model
      goog.events.listen collection, 'update', (e) ->
        done()
      collection.remove model

    test 'should not fire remove event', ->
      removeCalled = false
      goog.events.listen collection, 'remove', -> removeCalled = true
      collection.remove model
      assert.isFalse removeCalled

  suite 'remove item', ->
    test 'should fire remove event', ->
      removeCalled = false
      removed = null
      collection.add model
      goog.events.listen collection, 'remove', (e) ->
        removed = e.removed
        removeCalled = true
      collection.remove [model]
      assert.isTrue removeCalled, 'removeCalled'
      assert.deepEqual removed, [model]

    test 'should not fire remove, change events', ->
      removeCalled = changeCalled = false
      goog.events.listen collection, 'remove', -> removeCalled = true
      goog.events.listen collection, 'change', -> changeCalled = true
      collection.remove model
      assert.isFalse removeCalled
      assert.isFalse changeCalled

  suite 'contains', ->
    test 'should return true if obj is present', ->
      assert.isFalse collection.contains model
      collection.add model
      assert.isTrue collection.contains model

  suite 'removeIf', ->
    test 'should remove item', ->
      collection.add model
      assert.isTrue collection.contains model
      collection.removeIf (item) -> item == model
      assert.isFalse collection.contains model

  suite 'at', ->
    test 'should return item by index', ->
      collection.add model
      assert.equal collection.at(0), model

  suite 'toArray', ->
    test 'should return inner array', ->
      collection.add model
      assert.deepEqual collection.toArray(), [model]

  suite 'toJson', ->
    test 'should return inner array', ->
      collection.add model
      assert.deepEqual collection.toJson(true), [{}]

    test 'should pass noMetas to model toJson method', (done) ->
      collection = new Collection
      collection.add 'a': 1
      collection.at(0).toJson = (noMetas) ->
        assert.isTrue noMetas
        done()
      collection.toJson true

  suite 'bubbling events', ->
    test 'from inner model should work', ->
      called = 0
      innerModel = new Model
      collection.add innerModel
      goog.events.listen collection, 'change', (e) ->
        called++
      innerModel.set '1', 1
      assert.equal called, 1
      collection.remove innerModel
      assert.equal called, 1
      innerModel.set '1', 2
      assert.equal called, 1

    test 'from inner model (within other collection) should work', ->
      called = 0
      innerModel = new Model
      collection.add innerModel
      collection2 = new Collection
      collection2.add innerModel
      goog.events.listen collection, 'change', (e) ->
        called++
      innerModel.set '1', 1
      assert.equal called, 1
      collection.remove innerModel
      assert.equal called, 1
      innerModel.set '1', 2
      assert.equal called, 1

  suite 'find', ->
    test 'should find item', ->
      collection.add [
        a: 1
      ,
        b: 2
      ]
      found = collection.find (item) -> item.get('a') == 1
      assert.equal found.get('a'), 1
      found = collection.find (item) -> item.get('b') == 2
      assert.equal found.get('b'), 2
      found = collection.find (item) -> item.get('b') == 3
      assert.isNull found

  suite 'findById', ->
    test 'should find item by id', ->
      collection.add [
        id: 1
      ,
        id: 2
      ]
      found = collection.findById 1
      assert.equal found.getId(), 1
      found = collection.findById 2
      assert.equal found.getId(), 2
      found = collection.findById 3
      assert.isNull found

  suite 'findByClientId', ->
    test 'should find item by _cid', ->
      collection.add [
        id: 1, _cid: ':1'
      ,
        id: 2, _cid: ':2'
      ]
      found = collection.findByClientId ':1'
      assert.equal found.getId(), 1
      found = collection.findByClientId ':2'
      assert.equal found.getId(), 2
      found = collection.findByClientId ':3'
      assert.isNull found

  suite 'add object into collection', ->
    test 'should work', ->
      collection = new ChildCollection
      child = new Child
      child.set 'a', 1
      collection.add child
      assert.instanceOf collection.at(0), Child
      assert.equal collection.at(0).get('a'), 1

  suite 'clear', ->
    test 'should works', ->
      count = 0
      collection = new Collection [model, new Model]
      goog.events.listen collection, 'remove', -> count++
      collection.clear()
      assert.equal count, 1
      assert.isUndefined collection.at 0
      assert.isUndefined collection.at 1

  suite 'sort', ->
    test 'should fire sort event', (done) ->
      goog.events.listen collection, 'sort', (e) ->
        done()
      collection.sort()

    test 'should fire update event', (done) ->
      goog.events.listen collection, 'update', (e) ->
        done()
      collection.sort()

  suite 'sort by', ->
    test 'should sort collection', ->
      collection.add id: 1
      collection.add id: 2
      collection.add id: 3
      collection.sort by: (item) -> item.id
      assert.deepEqual collection.toJson(true), [
        {id: 1},
        {id: 2},
        {id: 3}
      ]

    test 'should sort added items', ->
      collection.sort by: (item) -> item.getId()
      collection.add id: 3
      collection.add id: 2
      collection.add id: 1
      assert.deepEqual collection.toJson(true), [
        {id: 1},
        {id: 2},
        {id: 3}
      ]

  suite 'sort by, reversed', ->
    test 'should sort collection', ->
      collection.add id: 1
      collection.add id: 2
      collection.add id: 3
      collection.sort reversed: true, by: (item) -> item.getId()
      assert.deepEqual collection.toJson(true), [
        {id: 3},
        {id: 2},
        {id: 1}
      ]

    test 'should sort added items', ->
      collection.sort reversed: true, by: (item) -> item.getId()
      collection.add id: 3
      collection.add id: 2
      collection.add id: 1
      assert.deepEqual collection.toJson(true), [
        {id: 3},
        {id: 2},
        {id: 1}
      ]

  suite 'filter', ->
    test 'should filter by function', ->
      arrangeCollectionWithItems()
      filtered = collection.filter (item) ->
        item.get('a') == 1
      , true
      assert.deepEqual filtered, [
        'a': 1, 'aa': 1.5
      ]

      filtered = collection.filter (item) ->
        item.get('a') == 2
      , true
      assert.deepEqual filtered, []

      filtered = collection.filter (item) ->
        item.get('a') == 1 || item.get('bb') == 2.5
      , true
      assert.deepEqual filtered, [
        'a': 1, 'aa': 1.5
      ,
        'b': 2, 'bb': 2.5
      ]

    test 'should filter by object', ->
      arrangeCollectionWithItems()
      filtered = collection.filter
        'a': 1
      , true
      assert.deepEqual filtered, [
        'a': 1, 'aa': 1.5
      ]

      filtered = collection.filter
        'a': 2
      , true
      assert.deepEqual filtered, []

      filtered = collection.filter
        'bb': 2.5
      , true
      assert.deepEqual filtered, [
        'b': 2, 'bb': 2.5
      ]

  suite 'each', ->
    test 'should call passed callback with each collection model', ->
      collection = new Collection
      arrangeCollectionWithItems()
      items = []
      collection.each (item) ->
        items.push item.toJson true
      assert.deepEqual items, [
        'a': 1, 'aa': 1.5
      ,
        'b': 2, 'bb': 2.5
      ,
        'c': 3, 'cc': 3.5
      ]

  suite 'multiple parent event propagation', ->
    test 'should work', ->
      collection1 = new Collection
      collection2 = new Collection
      model = new Model
      collection1.add model
      collection2.add model

      calls = ''
      goog.events.listen collection1, 'change', ->
        calls += 'col1called'
      goog.events.listen collection2, 'change', ->
        calls += 'col2called'
      model.set 'foo', 'bla'
      assert.equal calls, 'col1calledcol2called'

      calls = ''
      goog.events.listen collection1, 'update', ->
        calls += 'col1called'
      goog.events.listen collection2, 'update', ->
        calls += 'col2called'
      model.set 'foo', 'fok'
      assert.equal calls, 'col1calledcol2calledcol1calledcol2called'

  suite 'getUrl', ->
    test 'should return associated model url if collection url is empty', ->
      assert.equal collection.getUrl(), '/models'

    test 'should return string url', ->
      collection.url = '/todos'
      assert.equal collection.getUrl(), '/todos'

    test 'should return function url', ->
      collection.url = -> '/todos'
      assert.equal collection.getUrl(), '/todos'

  suite 'reset', ->
    test 'should replace a collection', ->
      collection.add 'a': 1, 'aa': 1.5
      assert.equal collection.getLength(), 1
      collection.reset 'b': 2, 'bb': 2.5
      assert.equal collection.getLength(), 1
      assert.deepEqual collection.toJson(true),
        ['b': 2, 'bb': 2.5]