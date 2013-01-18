suite 'este.app.Route', ->

  Route = este.app.Route

  route = null

  setup ->
    route = new Route

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf route, Route

    test 'should set path and presenter', ->
      presenter = {}
      route = new Route 'a', presenter
      assert.equal route.path, 'a'
      assert.equal route.presenter, presenter