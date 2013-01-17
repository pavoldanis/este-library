suite 'este.json', ->

  json = este.json

  suite 'equal', ->
    test 'should work for objects', ->
      a = 1: 'foo'
      b = 1: 'foo'
      assert.isTrue json.equal a, b

      a = 1: 'foo'
      b = 2: 'foo'
      assert.isFalse json.equal a, b

    test 'should work for nulls', ->
      a = null
      b = null
      assert.isTrue json.equal a, b