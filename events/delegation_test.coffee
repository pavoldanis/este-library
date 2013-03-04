suite 'este.events.Delegation', ->

  Delegation = este.events.Delegation

  element = null
  delegation = null

  setup ->
    element = document.createElement 'div'
    delegation = new Delegation element, ['click', 'mouseover', 'mouseout']
    delegation.targetFilter = (el) ->
      el.className == 'target'
    delegation.targetParentFilter = (el) ->
      el.className == 'parent'

  suite 'Delegation.create', ->
    test 'should return delegation', ->
      delegation = new Delegation element, ['click', 'mouseover', 'mouseout']
      assert.instanceOf delegation, Delegation

  suite 'should dispatch click', ->
    test 'on element with className .target and with parent className .parent', (done) ->
      goog.events.listen delegation, 'click', ->
        done()
      goog.events.fireListeners element, 'click', false,
        type: 'click'
        target:
          className: 'target'
          parentNode:
            className: 'parent'

    test 'on element with className .target and without parent', (done) ->
      delete delegation.targetParentFilter
      goog.events.listen delegation, 'click', ->
        done()
      goog.events.fireListeners element, 'click', false,
        type: 'click'
        target:
          className: 'target'

    test 'on element inside el with className .target and with parent className .parent', (done) ->
      target =
        className: 'target'
        parentNode:
          className: 'parent'
      goog.events.listen delegation, 'click', (e) ->
        assert.equal e.target, target, 'target should be updated'
        done()
      goog.events.fireListeners element, 'click', false,
        type: 'click'
        target:
          parentNode: target

  suite 'should not dispatch click', ->
    test 'on element without className .target', ->
      called = false
      goog.events.listen delegation, 'click', -> called = true
      goog.events.fireListeners element, 'click', false,
        type: 'click'
        target: {}
      assert.isFalse called

    test 'on element with className .target and without parent className .parent', ->
      called = false
      goog.events.listen delegation, 'click', -> called = true
      goog.events.fireListeners element, 'click', false,
        type: 'click'
        target:
          className: 'target'
          parentNode: {}
      assert.isFalse called

  suite 'should not dispatch mouseover', ->
    test 'on element inside target', ->
      called = false
      target =
        className: 'target'
        parentNode:
          className: 'parent'
      goog.events.listen delegation, 'mouseover', -> called = true
      goog.events.fireListeners element, 'mouseover', false,
        type: 'mouseover'
        relatedTarget: target
        target:
          parentNode: target
      assert.isFalse called

  suite 'should not dispatch mouseout', ->
    test 'on element inside target', ->
      called = false
      target =
        className: 'target'
        parentNode:
          className: 'parent'
      goog.events.listen delegation, 'mouseout', -> called = true
      goog.events.fireListeners element, 'mouseout', false,
        type: 'mouseout'
        relatedTarget: target
        target:
          parentNode: target
      assert.isFalse called

  suite 'w3c', ->
    suite 'focus', ->
      test 'should call addEventListener', (done) ->
        element.addEventListener = (type, fn, capture) ->
          assert.equal type, 'focus'
          assert.isFunction fn
          assert.isTrue capture
          done()
        delegation = new Delegation element, 'focus'

    suite 'blur', ->
      test 'should call addEventListener', (done) ->
        element.addEventListener = (type, fn, capture) ->
          assert.equal type, 'blur'
          assert.isFunction fn
          assert.isTrue capture
          done()
        delegation = new Delegation element, 'blur'

  suite 'ie', ->
    suite 'focus', ->
      test 'should call addEventListener', (done) ->
        element.addEventListener = (type, fn, capture) ->
          assert.equal type, 'focusin'
          assert.isFunction fn
          assert.isFalse capture
          done()
        delegation = new Delegation element, 'focus', true

    suite 'blur', ->
      test 'should call addEventListener', (done) ->
        element.addEventListener = (type, fn, capture) ->
          assert.equal type, 'focusout'
          assert.isFunction fn
          assert.isFalse capture
          done()
        delegation = new Delegation element, 'blur', true