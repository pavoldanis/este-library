suite 'este.validators.number', ->

  number = null

  setup ->
    number = este.validators.number()()

  suite 'validate', ->
    test '123 should be valid', ->
      number.value = '123'
      assert.isTrue number.validate()

    test '123.3 should be valid', ->
      number.value = '123.3'
      assert.isTrue number.validate()

    test '"1e1" (scientific notation) should be valid', ->
      number.value = '1e1'
      assert.isTrue number.validate()

    test '""should be valid', ->
      number.value = ''
      assert.isTrue number.validate()

    test 'foo should be invalid', ->
      number.value = 'foo'
      assert.isFalse number.validate()

    test '" " should be invalid', ->
      number.value = ' '
      assert.isFalse number.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal number.getMsg(), 'Please enter a valid number.'

    test 'should return alternative message', ->
      getMsg = -> 'This is not number.'
      number = este.validators.number(getMsg)()
      assert.equal number.getMsg(), getMsg()