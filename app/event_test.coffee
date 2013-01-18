suite 'este.app.Event', ->

  Event = este.app.Event

  event = null

  setup ->
    event = new Event

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf event, Event

    test 'should set type and request', ->
      request = {}
      event = new Event 'foo', request
      assert.equal event.type, 'foo'
      assert.equal event.request, request