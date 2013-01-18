suite 'este.app.Presenter', ->

  Presenter = este.app.Presenter

  presenter = null
  createUrl = null
  redirect = null
  screenEl = null
  screen = null
  view = null
  storage = null

  setup ->
    presenter = new Presenter
    createUrl = ->
    redirect = ->
    presenter.createUrl = createUrl
    presenter.redirect = redirect
    screenEl = document.createElement 'div'
    screen =
      getElement: -> screenEl
      show: ->
      dispose: ->
    view =
      element: null
      getElement: -> @element
      render: -> @element = {}
      dispose: ->
    storage =
      dispose: ->
    presenter.screen = screen
    presenter.view = view
    presenter.storage = storage

  suite 'constructor', ->
    test 'should work', ->
      assert.instanceOf presenter, Presenter

  suite 'load', ->
    test 'should return instance of goog.result.SimpleResult', ->
      result = presenter.load()
      assert.instanceOf result, goog.result.SimpleResult

    test 'should return successful instance of goog.result.SimpleResult', ->
      result = presenter.load()
      assert.equal result.getState(), goog.result.Result.State.SUCCESS

  suite 'show', ->
    suite 'first call', ->
      test 'should call view.render then screen.show etc.', ->
        calls = ''
        view.render = (parentElement) ->
          assert.equal view.createUrl, createUrl
          assert.equal view.redirect, redirect
          assert.equal parentElement, screenEl
          calls += 'r'
        screen.show = (el) ->
          assert.equal el, view.getElement()
          calls += 's'
        presenter.show()
        assert.equal calls, 'rs'

    suite 'second call', ->
      test 'should call view.enterDocument then screen.show etc.', ->
        calls = ''
        presenter.show()
        view.enterDocument = ->
          assert.equal view.createUrl, createUrl
          assert.equal view.redirect, redirect
          calls += 'e'
        screen.show = (el) ->
          assert.equal el, view.getElement()
          calls += 's'
        presenter.show()
        assert.equal calls, 'es'

  suite 'hide', ->
    test 'should call view exitDocument', (done) ->
      view.exitDocument = -> done()
      presenter.hide()

  suite 'dispose', ->
    test 'should dispose view', (done) ->
      presenter.view.dispose = -> done()
      presenter.dispose()