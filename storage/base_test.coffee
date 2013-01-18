suite 'este.storage.Base', ->

  Base = este.storage.Base

  base = null

  setup ->
    base = new Base

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf base, Base