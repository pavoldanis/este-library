suite 'este.validators.format', ->

  format = null

  setup ->
    format = este.validators.format(/^\d+$/)()

  suite 'validate', ->
    test '123 should be valid', ->
      format.value = '123'
      assert.isTrue format.validate()

    test '""should be valid', ->
      format.value = ''
      assert.isTrue format.validate()

    test 'foo@@bla.com should not be valid', ->
      format.value = 'foo@@bla.com'
      assert.isFalse format.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal format.getMsg(), 'Please enter a value in correct format.'

    test 'should return alternative message', ->
      getMsg = -> 'This is not format.'
      format = este.validators.format(/^\d+$/, getMsg)()
      assert.equal format.getMsg(), getMsg()