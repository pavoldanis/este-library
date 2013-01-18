suite 'este.app.screen.OneView', ->

  OneView = este.app.screen.OneView

  oneView = null
  oneViewEl = null

  setup ->
    oneView = new OneView
    oneViewEl = document.createElement 'div'
    oneView.decorate oneViewEl

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf oneView, OneView

  suite 'show', ->
    test 'should append element', (done) ->
      el = document.createElement 'div'
      oneViewEl.appendChild = (child) ->
        assert.equal child, el
        done()
      oneView.show el

    test 'should remove previously element', (done) ->
      el1 = document.createElement 'div'
      el2 = document.createElement 'div'
      firstAdded = false
      firstRemoved = false
      oneViewEl.removeChild = (child) ->
        assert.equal child, el1
        firstRemoved = true
      oneViewEl.appendChild = (child) ->
        if !firstAdded
          firstAdded = true
          assert.equal child, el1
        else
          assert.isTrue firstRemoved
          assert.equal child, el2
          done()
      oneView.show el1
      oneView.show el2