suite 'este.Base', ->

  Base = este.Base

  base = null

  setup ->
    base = new este.Base

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf base, este.Base

  suite 'on', ->
    test 'should be alias for getHandler().listen', (done) ->
      base.getHandler = ->
        listen: (a, b, c, d, e) ->
          assert.equal a, 1
          assert.equal b, 2
          assert.equal c, 3
          assert.equal d, 4
          assert.equal e, 5
          done()
      base.on 1, 2, 3, 4, 5

  suite 'once', ->
    test 'should be alias for getHandler().listenOnce', (done) ->
      base.getHandler = ->
        listenOnce: (a, b, c, d, e) ->
          assert.equal a, 1
          assert.equal b, 2
          assert.equal c, 3
          assert.equal d, 4
          assert.equal e, 5
          done()
      base.once 1, 2, 3, 4, 5

  suite 'off', ->
    test 'should be alias for getHandler().unlisten', (done) ->
      base.getHandler = ->
        unlisten: (a, b, c, d, e) ->
          assert.equal a, 1
          assert.equal b, 2
          assert.equal c, 3
          assert.equal d, 4
          assert.equal e, 5
          done()
      base.off 1, 2, 3, 4, 5