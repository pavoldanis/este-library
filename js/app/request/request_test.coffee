suite 'este.app.Request', ->

  Request = este.app.Request

  presenter = null
  params = null
  request = null

  setup ->
    presenter = {}
    params = 1: 'foo'
    request = new Request presenter, params

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf request, Request

  suite 'equal', ->
    test 'should equal same presenter and params', ->
      sameRequest = new Request presenter, params
      assert.isTrue request.equal sameRequest

    test 'should equal same presenter without params', ->
      request = new Request presenter
      sameRequest = new Request presenter
      assert.isTrue request.equal sameRequest

    test 'should not equal same presenter and different params', ->
      differentRequest = new Request presenter, 2: 'bla'
      assert.isFalse request.equal differentRequest

    test 'should not equal different presenter and same params', ->
      differentRequest = new Request {}, params
      assert.isFalse request.equal differentRequest