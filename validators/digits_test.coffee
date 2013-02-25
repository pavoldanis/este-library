suite 'este.validators.digits', ->

  digits = null

  setup ->
    digits = este.validators.digits()()

  suite 'validate', ->
    test '123 should be valid', ->
      digits.value = '123'
      assert.isTrue digits.validate()

    test '"" should be valid', ->
      digits.value = ''
      assert.isTrue digits.validate()

    test '123.3 should be invalid', ->
      digits.value = '123.3'
      assert.isFalse digits.validate()

    test '"1e1" (scientific notation) should be invalid', ->
      digits.value = '1e1'
      assert.isFalse digits.validate()

    test 'foo should be invalid', ->
      digits.value = 'foo'
      assert.isFalse digits.validate()

    test '" " should be invalid', ->
      digits.value = ' '
      assert.isFalse digits.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal digits.getMsg(), 'Please enter only digits.'

    test 'should return alternative message', ->
      getMsg = -> 'This is not digits.'
      digits = este.validators.digits(getMsg)()
      assert.equal digits.getMsg(), getMsg()