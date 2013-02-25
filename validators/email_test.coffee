suite 'este.validators.email', ->

  email = null

  setup ->
    email = este.validators.email()()

  suite 'validate', ->
    test 'foo@bla.com should be valid', ->
      email.value = 'foo@bla.com'
      assert.isTrue email.validate()

    test '""should be valid', ->
      email.value = ''
      assert.isTrue email.validate()

    test 'foo@@bla.com should not be valid', ->
      email.value = 'foo@@bla.com'
      assert.isFalse email.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal email.getMsg(), 'Please enter a valid email address.'

    test 'should return alternative message', ->
      getMsg = -> 'This is not email.'
      email = este.validators.email(getMsg)()
      assert.equal email.getMsg(), getMsg()