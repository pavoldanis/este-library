###*
  @fileoverview Non destructive innerHTML update. Preserve form fields states,
  prevents images flickering, changes only changed nodes.
  EXPERIMENTAL

  How does it work
    element is clonned (without content)
    clone.innerHTML = html
    element and clone are normalized
    then clone is merged with element, see mergeInternal
    only changed elements are touched

  este.dom.merge el, '<p>new html</p>'

  TODO:
    better algorithm for temporally injected nodes via siblings checks
    consider outerHTML optimalization
    consider string2pseudoDom, then extract partial changes

  scenarios for end2end tests
    merge.html demo (form state is preserved)
    todomvc demo (exact behaviour)
  @see ../demos/merge.html
###

goog.provide 'este.dom.merge'
goog.provide 'este.dom.Merge'

goog.require 'este.dom'
goog.require 'este.json'
goog.require 'goog.array'

###*
  @param {Element} element
  @param {string} html
###
este.dom.merge = (element, html) ->
  merge = new este.dom.Merge element, html
  merge.merge()
  return

class este.dom.Merge

  ###*
    @param {Element} element
    @param {string} html
    @constructor
  ###
  constructor: (@element, @html) ->

  ###*
    @type {Element}
    @protected
  ###
  element: null

  ###*
    @type {string}
    @protected
  ###
  html: ''

  ###*
    Merge html into element.
  ###
  merge: ->
    clone = @element.cloneNode false
    clone.innerHTML = @html
    clone.normalize()
    @element.normalize()
    @mergeInternal @element, clone

  ###*
    @param {Element} to
    @param {Element} from
    @protected
  ###
  mergeInternal: (to, from) ->
    toNodes = goog.array.toArray to.childNodes
    fromNodes = goog.array.toArray from.childNodes

    if toNodes.length > fromNodes.length
      howMany = toNodes.length - fromNodes.length
      for node in toNodes.splice fromNodes.length, howMany
        goog.dom.removeNode node

    for fromNode, i in fromNodes
      toNode = toNodes[i]

      if !toNode
        to.appendChild fromNode
        continue

      if toNode.nodeType == 3 && fromNode.nodeType == 3
        toNode.data = fromNode.data
        continue

      if toNode.tagName != fromNode.tagName
        toNode.parentNode.replaceChild fromNode, toNode
        continue

      @mergeAttributes toNode, fromNode
      @mergeInternal toNode, fromNode
    return

  ###*
    @param {Element} toNode
    @param {Element} fromNode
    @protected
  ###
  mergeAttributes: (toNode, fromNode) ->
    # 'checked' and 'selected' can be attribute less
    # http://stackoverflow.com/questions/4228658/what-values-for-checked-and-selected-are-false
    valueLessFields =
      'INPUT': 'checked'
      'OPTION': 'selected'
    valueLessFieldProp = valueLessFields[fromNode.tagName]
    valueLessFieldValue = fromNode.hasAttribute valueLessFieldProp

    # remove all toNode.attrs which are not on fromNode
    if toNode.hasAttributes()
      for attr in goog.array.toArray toNode.attributes
        continue if fromNode.hasAttribute attr.name
        toNode.removeAttribute attr.name

    if fromNode.hasAttributes()
      for attr in goog.array.toArray fromNode.attributes
        if attr.name == 'value'
          continue if toNode[attr.name] == attr.value
          toNode[attr.name] = attr.value
        else
          continue if toNode.getAttribute(attr.name) == attr.value
          toNode.setAttribute attr.name, attr.value

    if valueLessFieldProp
      toNode[valueLessFieldProp] = valueLessFieldValue

    return