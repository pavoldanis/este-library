###*
	@fileoverview Simple and useful event delegation.
	@see ../demos/delegation.html
###
goog.provide 'este.events.Delegation'
goog.provide 'este.events.Delegation.create'

goog.require 'este.Base'
goog.require 'goog.dom'
goog.require 'goog.events'
goog.require 'goog.userAgent'

class este.events.Delegation extends este.Base

	###*
		@param {Element} element
		@param {Array.<string>|string} types
		@param {boolean=} forceIE
		@constructor
		@extends {este.Base}
	###
	constructor: (@element, types, forceIE) ->
		types = [types] if typeof types == 'string'
		for type in types
			if type in ['focus', 'blur']
				isIe = forceIE || goog.userAgent.IE
				if isIe
					type = 'focusin' if type == 'focus'
					type = 'focusout' if type == 'blur'
				@on @element, type, @onElementType, !isIe
			else
				@on @element, type, @onElementType
		super()

	###*
		@param {Element} element
		@param {Array.<string>|string} eventTypes
		@param {function(Node): boolean=} targetFilter
		@param {function(Node): boolean=} targetParentFilter
		@return {este.events.Delegation}
	###
	@create: (element, eventTypes, targetFilter, targetParentFilter) ->
		delegation = new este.events.Delegation element, eventTypes
		delegation.targetFilter = targetFilter if targetFilter
		delegation.targetParentFilter = targetParentFilter if targetParentFilter
		delegation

	###*
		@type {Element}
		@protected
	###
	element: null

	###*
		@type {function(Node): boolean}
	###
	targetFilter: (node) ->
		true

	###*
		@type {function(Node): boolean}
	###
	targetParentFilter: (node) ->
		true

	###*
		@param {goog.events.BrowserEvent} e
		@protected
	###
	onElementType: (e) ->
		return if !@matchFilter e
		@dispatchEvent e

	###*
		@param {goog.events.BrowserEvent} e
		@return {boolean} True for match
		@protected
	###
	matchFilter: (e) ->
		targetMatched = false
		targetParentMatched = null
		element = e.target
		target = null

		while element
			if !targetMatched
				targetMatched = @targetFilter element
				target = element
			else if !targetParentMatched
				targetParentMatched = @targetParentFilter element
			else
				break
			element = element.parentNode

		return false if !targetMatched || targetParentMatched == false

		e.target = target
		if e.type in ['mouseover', 'mouseout']
			return !e.relatedTarget || !goog.dom.contains target, e.relatedTarget

		true