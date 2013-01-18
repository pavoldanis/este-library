suite 'este.app.request.Queue', ->

  Queue = este.app.request.Queue

  queue = null
  request = null

  setup ->
    queue = new Queue
    request = mockRequest()

  mockRequest = ->
    equal: (req) -> @ == req

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf queue, Queue

  suite 'dequeue', ->
    test 'should return false for empty queue', ->
      assert.isFalse queue.dequeue request

    test 'should return false for queue with another request', ->
      queue.add mockRequest()
      assert.isFalse queue.dequeue request

    test 'should return true and clear queue with same request', ->
      queue.add request
      assert.isTrue queue.dequeue request
      assert.isTrue queue.isEmpty()

    test 'should return true and clear queue with two requests', ->
      queue.add mockRequest()
      queue.add request
      assert.isTrue queue.dequeue request
      assert.isTrue queue.isEmpty()

  suite 'isEmpty', ->
    test 'should work', ->
      assert.isTrue queue.isEmpty()
      queue.add request
      assert.isFalse queue.isEmpty()

  suite 'clear', ->
    test 'should clear queue', ->
      queue.add request
      queue.clear()
      assert.isTrue queue.isEmpty()

  suite 'dispose', ->
    test 'should clear queue', ->
      queue.add request
      queue.dispose()
      assert.isTrue queue.isEmpty()