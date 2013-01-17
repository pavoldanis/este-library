suite 'este.demos.app.todomvc.todos.Collection', ->

  Collection = este.demos.app.todomvc.todos.Collection

  collection = null

  setup ->
    json = [
      completed: false
    ,
      completed: false
    ]
    collection = new Collection json

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf collection, Collection

  suite 'toggleCompleted', ->
    test 'should set all items completed', ->
      assert.isFalse collection.at(0).get 'completed'
      assert.isFalse collection.at(1).get 'completed'
      collection.toggleCompleted true
      assert.isTrue collection.at(0).get 'completed'
      assert.isTrue collection.at(1).get 'completed'
      collection.toggleCompleted false
      assert.isFalse collection.at(0).get 'completed'
      assert.isFalse collection.at(1).get 'completed'

  suite 'clearCompleted', ->
    test 'should remove completed item from collection', ->
      assert.equal 2, collection.getLength()
      collection.at(0).set 'completed', true
      collection.clearCompleted()
      assert.equal 1, collection.getLength()
      assert.equal collection.at(0).get('completed'), false

  suite 'getRemainingCount', ->
    test 'should return number of incomplete items', ->
      assert.equal 2, collection.getRemainingCount()
      collection.at(0).set 'completed', true
      assert.equal 1, collection.getRemainingCount()
      collection.at(1).set 'completed', true
      assert.equal 0, collection.getRemainingCount()

  suite 'getCompletedCount', ->
    test 'should return number of incomplete items', ->
      assert.isFalse collection.allCompleted()
      collection.at(0).set 'completed', true
      assert.isFalse collection.allCompleted()
      collection.at(1).set 'completed', true
      assert.isTrue collection.allCompleted()

  suite 'filterByState', ->
    test 'should work', ->
      json = [
        completed: false
      ,
        completed: true
      ]
      collection = new Collection json

      completed = collection.filterByState 'completed'
      assert.lengthOf completed, 1

      active = collection.filterByState 'active'
      assert.lengthOf active, 1

      all = collection.filterByState 'all'
      assert.lengthOf all, 2