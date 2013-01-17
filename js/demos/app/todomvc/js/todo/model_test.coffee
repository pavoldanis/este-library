suite 'este.demos.app.todomvc.todo.Model', ->

  Model = este.demos.app.todomvc.todo.Model

  model = null

  setup ->
    model = new Model

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf model, Model

    test 'should set default value', ->
      json = model.toJson true
      assert.deepEqual json,
        title: ''
        completed: false
        editing: false

  suite 'set title', ->
    test 'should be trimmed', ->
      model.set 'title', '  foo  '
      assert.equal model.get('title'), 'foo'

    test 'should be required', ->
      errors = model.validate()
      assert.deepEqual errors,
        title: required: true

  suite 'toggleCompleted', ->
    test 'should toggle completed', ->
      assert.isFalse model.get 'completed'
      model.toggleCompleted()
      assert.isTrue model.get 'completed'
      model.toggleCompleted()
      assert.isFalse model.get 'completed'