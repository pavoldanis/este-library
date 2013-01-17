suite 'este.app.View', ->

  View = este.app.View

  view = null

  setup ->
    view = new View

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf view, View

  suite 'createUrl', ->
    test 'should throw error', ->
      error = null
      try
        view.createUrl()
      catch e
        error = e
      assert.isNotNull error

  suite 'redirect', ->
    test 'should throw error', ->
      error = null
      try
        view.redirect()
      catch e
        error = e
      assert.isNotNull error