suite 'este.validators.maxLength', ->

  maxLength = null

  setup ->
    maxLength = este.validators.maxLength(3)()

  suite 'validate', ->
    test 'should return false for abcd', ->
      maxLength.value = 'abcd'
      assert.isFalse maxLength.validate()

    test 'should return true for abc', ->
      maxLength.value = 'abc'
      assert.isTrue maxLength.validate()

    test 'should return true for ""', ->
      maxLength.value = ''
      assert.isTrue maxLength.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal maxLength.getMsg(), 'Please enter no more than 3 characters.'

    test 'should return alternative message', ->
      getMsg = -> "Foo #{@maxLength}"
      maxLength = este.validators.maxLength(3, getMsg)()
      assert.equal maxLength.getMsg(), 'Foo 3'