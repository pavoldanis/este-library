###*
  @fileoverview Bubbled submit event.
###
goog.provide 'este.events.SubmitHandler'
goog.provide 'este.events.SubmitHandler.EventType'

goog.require 'este.Base'
goog.require 'este.dom'
goog.require 'goog.userAgent'

class este.events.SubmitHandler extends este.Base

  ###*
    @param {Element|Document=} node
    @param {boolean=} preventDefault
    @constructor
    @extends {este.Base}
  ###
  constructor: (node = document, @preventDefault = true) ->
    super()
    # IE doesn't bubble submit event, but focusin with lazy submit registration
    # workarounds it well.
    eventType = if goog.userAgent.IE && !goog.userAgent.isDocumentMode 9
      'focusin'
    else
      'submit'
    @on node, eventType, @

  ###*
    @enum {string}
  ###
  @EventType:
    SUBMIT: 'submit'

  ###*
    @type {boolean}
    @protected
  ###
  preventDefault: true

  ###*
    @param {goog.events.BrowserEvent} e
    @protected
  ###
  handleEvent: (e) ->
    if e.type == 'focusin'
      form = goog.dom.getAncestorByTagNameAndClass e.target, 'form'
      @on form, 'submit', @ if form
      return
    `var target = /** @type {Element} */ (e.target)`
    e.json = este.dom.serializeForm target
    e.preventDefault() if @preventDefault
    @dispatchEvent e