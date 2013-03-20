suite 'este.validators.minLength', ->

  minLength = null

  setup ->
    minLength = este.validators.minLength(3)()

  suite 'validate', ->
    test 'should return false for ab', ->
      minLength.value = 'ab'
      assert.isFalse minLength.validate()

    test 'should return true for ""
      (only required validator requires non empty input)', ->
      minLength.value = ''
      assert.isTrue minLength.validate()

    test 'should return true for abc', ->
      minLength.value = 'abc'
      assert.isTrue minLength.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal minLength.getMsg(), 'Please enter at least 3 characters.'

    test 'should return alternative message', ->
      getMsg = -> "Foo #{@minLength}"
      minLength = este.validators.minLength(3, getMsg)()
      assert.equal minLength.getMsg(), 'Foo 3'