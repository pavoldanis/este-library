suite 'este.validators.exclusion', ->

  exclusion = null

  setup ->
    exclusion = este.validators.exclusion(['Foo', 'Bla'])()

  suite 'validate', ->
    test 'should return true for falsy', ->
      exclusion.value = undefined
      assert.isTrue exclusion.validate()
      exclusion.value = null
      assert.isTrue exclusion.validate()
      exclusion.value = ''
      assert.isTrue exclusion.validate()

    test 'should return false for "Foo"', ->
      exclusion.value = 'Foo'
      assert.isFalse exclusion.validate()

    test 'should return false for "Bla"', ->
      exclusion.value = 'Bla'
      assert.isFalse exclusion.validate()

    test 'should return true for "a"', ->
      exclusion.value = 'a'
      assert.isTrue exclusion.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      exclusion.value = 'Foo'
      assert.equal exclusion.getMsg(), '\'Foo\' is not allowed.'

    test 'should return alternative message', ->
      getMsg = -> "Foo #{@exclusion}"
      exclusion = este.validators.exclusion(['Foo', 'Bla'], getMsg)()
      assert.equal exclusion.getMsg(), 'Foo Foo,Bla'