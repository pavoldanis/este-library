suite 'este.ui.Component', ->

  Component = este.ui.Component

  component = null

  setup ->
    component = new Component

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf component, Component

  suite 'on', ->
    test 'should alias getHandler().listen', (done) ->
      component.enterDocument()
      component.getHandler = ->
        listen: (a, b, c, d, e) ->
          assert.equal a, 1
          assert.equal b, 2
          assert.equal c, 3
          assert.equal d, 4
          assert.equal e, 5
          done()
      component.on 1, 2, 3, 4, 5

    test 'should throw exception if called outside of document', (done) ->
      try
        component.on {attachEvent: ->}, 'foo', ->
      catch e
        done()

    test 'should not throw exception if called in document', ->
      called = false
      component.enterDocument()
      try
        component.on {attachEvent: ->}, 'foo', ->
      catch e
        called = true
      assert.isFalse called

  suite 'off', ->
    test 'should alias getHandler().unlisten', (done) ->
      component.getHandler = ->
        unlisten: (a, b, c, d, e) ->
          assert.equal a, 1
          assert.equal b, 2
          assert.equal c, 3
          assert.equal d, 4
          assert.equal e, 5
          done()
      component.off 1, 2, 3, 4, 5

  suite 'delegate', ->
    suite 'dom events', ->
      test 'should delegate to element by selector', (done) ->
        component.render()
        component.delegate
          '#foo click': ->
            done()
        goog.events.fireListeners component.getElement(), 'click', false,
          type: 'click'
          target:
            id: 'foo'

      test 'should delegate to element by selector via parent', (done) ->
        component.render()
        component.delegate
          '#foo click': ->
            done()
        goog.events.fireListeners component.getElement(), 'click', false,
          type: 'click'
          target:
            parentNode:
              id: 'foo'

      test 'should delegate to element by selector more types', ->
        calls = 0
        component.render()
        fn = -> calls++
        component.delegate
          '#foo mousedown,mouseup': fn
        goog.events.fireListeners component.getElement(), 'mousedown', false,
          type: 'mousedown'
          target:
            id: 'foo'
        goog.events.fireListeners component.getElement(), 'mouseup', false,
          type: 'mouseup'
          target:
            id: 'foo'
        assert.equal calls, 2

      test 'should be disposed after exitDocument', ->
        called = false
        listenerCount = goog.events.getTotalListenerCount()
        component.render()
        component.delegate
          '#foo click': ->
            called = true
        component.exitDocument()
        goog.events.fireListeners component.getElement(), 'click', false,
          type: 'click'
          target:
            id: 'foo'
        assert.isFalse called
        assert.equal goog.events.getTotalListenerCount(), listenerCount

    suite 'key events', ->
      test 'should delegate to element by selector', (done) ->
        component.render()
        component.delegate
          '.foo 13': ->
            done()
        goog.events.fireListeners component.keyHandler, 'key', false,
          type: 'key'
          keyCode: 13
          target:
            className: 'foo'

      test 'should delegate to element by selector via parent', (done) ->
        component.render()
        component.delegate
          '.foo 13': ->
            done()
        goog.events.fireListeners component.keyHandler, 'key', false,
          type: 'key'
          keyCode: 13
          target:
            parentNode:
              className: 'foo'

      test 'should be disposed after exitDocument', ->
        listenerCount = goog.events.getTotalListenerCount()
        component.render()
        component.delegate
          '.foo 13': ->
        disposeCalled = false
        component.keyHandler.dispose = ->
          disposeCalled = true
          goog.base @, 'dispose'
        component.exitDocument()
        assert.isTrue disposeCalled
        assert.equal goog.events.getTotalListenerCount(), listenerCount

    suite 'tap events', ->
      test 'should delegate to element by selector', (done) ->
        component.render()
        component.delegate
          '.foo tap': ->
            done()
        goog.events.fireListeners component.tapHandler, 'tap', false,
          type: 'tap'
          target:
            className: 'foo'

      test 'should delegate to element by selector via parent', (done) ->
        component.render()
        component.delegate
          '.foo tap': ->
            done()
        goog.events.fireListeners component.tapHandler, 'tap', false,
          type: 'key'
          keyCode: 'tap'
          target:
            parentNode:
              className: 'foo'

      test 'should be disposed after exitDocument', ->
        listenerCount = goog.events.getTotalListenerCount()
        component.render()
        component.delegate
          '.foo tap': ->
        disposeCalled = false
        component.tapHandler.dispose = ->
          disposeCalled = true
          goog.base @, 'dispose'
        component.exitDocument()
        assert.isTrue disposeCalled
        assert.equal goog.events.getTotalListenerCount(), listenerCount

    suite 'submit events', ->
      test 'should delegate to element by selector', (done) ->
        component.render()
        component.delegate
          '.foo submit': ->
            done()
        goog.events.fireListeners component.submitHandler, 'submit', false,
          type: 'submit'
          target:
            className: 'foo'

      test 'should delegate to element by selector via parent', (done) ->
        component.render()
        component.delegate
          '.foo submit': ->
            done()
        goog.events.fireListeners component.submitHandler, 'submit', false,
          type: 'key'
          keyCode: 'submit'
          target:
            parentNode:
              className: 'foo'

      test 'should be disposed after exitDocument', ->
        listenerCount = goog.events.getTotalListenerCount()
        component.render()
        component.delegate
          '.foo submit': ->
        disposeCalled = false
        component.submitHandler.dispose = ->
          disposeCalled = true
          goog.base @, 'dispose'
        component.exitDocument()
        assert.isTrue disposeCalled
        assert.equal goog.events.getTotalListenerCount(), listenerCount

  suite 'registerEvents', ->
    test 'should be called from enterDocument', (done) ->
      component.registerEvents = ->
        done()
      component.enterDocument()
