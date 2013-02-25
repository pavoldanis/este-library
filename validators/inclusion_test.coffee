suite 'este.validators.inclusion', ->

  inclusion = null

  setup ->
    inclusion = este.validators.inclusion(['Foo', 'Bla'])()

  suite 'validate', ->
    test 'should return true for falsy', ->
      inclusion.value = undefined
      assert.isTrue inclusion.validate()
      inclusion.value = null
      assert.isTrue inclusion.validate()
      inclusion.value = ''
      assert.isTrue inclusion.validate()

    test 'should return false for "a"', ->
      inclusion.value = 'a'
      assert.isFalse inclusion.validate()

    test 'should return true for "Foo"', ->
      inclusion.value = 'Foo'
      assert.isTrue inclusion.validate()

    test 'should return true for "Bla"', ->
      inclusion.value = 'Bla'
      assert.isTrue inclusion.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal inclusion.getMsg(), 'Please enter one of these values: Foo, Bla.'

    test 'should return alternative message', ->
      getMsg = -> "Foo #{@inclusion}"
      inclusion = este.validators.inclusion(['Foo', 'Bla'], getMsg)()
      assert.equal inclusion.getMsg(), 'Foo Foo,Bla'