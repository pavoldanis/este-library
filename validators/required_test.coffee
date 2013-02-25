suite 'este.validators.required', ->

  required = null

  setup ->
    required = este.validators.required()()

  suite 'validate', ->
    suite 'should return false for', ->
      test 'empty string', ->
        required.value = ''
        assert.isFalse required.validate()

      test 'string with whitespaces only', ->
        required.value = '  '
        assert.isFalse required.validate()

      test 'empty array', ->
        required.value = []
        assert.isFalse required.validate()

      test 'null', ->
        required.value = null
        assert.isFalse required.validate()

      test 'undefined', ->
        required.value = undefined
        assert.isFalse required.validate()

    suite 'should return true for', ->
      test 'non empty string', ->
        required.value = 'a'
        assert.isTrue required.validate()

      test 'non empty array', ->
        required.value = 'a'
        assert.isTrue required.validate()

      test 'number', ->
        required.value = 0
        assert.isTrue required.validate()

      test 'false', ->
        required.value = false
        assert.isTrue required.validate()

  suite 'getMsg', ->
    test 'should return message', ->
      assert.equal required.getMsg(), 'This field is required.'

    test 'should return alternative message', ->
      getMsg = -> 'Person name is required.'
      required = este.validators.required(getMsg)()
      assert.equal required.getMsg(), getMsg()