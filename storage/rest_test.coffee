suite 'este.storage.Rest', ->

  Rest = este.storage.Rest

  rest = null
  namespace = null

  setup ->
    namespace = 'foo'
    rest = new Rest namespace

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf rest, Rest

    test 'should replace version parametr in namespace', ->
      namespace = 'https://api.mongolab.com/api/:version/databases'
      rest = new Rest namespace, 1
      assert.equal rest.namespace, 'https://api.mongolab.com/api/1/databases'

  suite 'getRestUrl', ->
    test 'should append url', ->
      url = rest.getRestUrl 'bla'
      assert.equal url, 'foo/bla'

    test 'should append id', ->
      url = rest.getRestUrl 'bla', '1'
      assert.equal url, 'foo/bla/1'

    test 'should append id', ->
      url = rest.getRestUrl 'bla', ''
      assert.equal url, 'foo/bla'
