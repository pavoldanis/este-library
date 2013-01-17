###*
  @fileoverview Fix CoffeeScript compiled code for Closure Compiler.
  Only Class needs to be fixed, because compiler does not like
  immediately-invoked function expressions (IIFE), which has to be
  removed. Note that you can still reference Class without whole namespace.
  It means, you can still write
    Foo.EventType.CLICK
  instead of long
    very.long.namespace.Foo.EventType.CLICK

  Notes
    do not declare class inside function, it does not work (yet)

  There are some edge issues, which will be fixed soon.
    do not use splats with annotations (foo, bla...)
    do not use 'foo in someArray', foo in [a, ...] is ok

  TODO:
    use Esprima for parsing
    new compiler should be able to parse nested annotations, check it
###

goog.provide 'este.dev.CoffeeForClosure'
goog.provide 'este.dev.coffeeForClosure'

class este.dev.CoffeeForClosure

  ###*
    @param {string} source
    @constructor
  ###
  constructor: (@source) ->
    # consider newlines canonization
    # str.replace(/(\r\n|\r|\n)/g, '\n');
    @replaces = []

  ###*
    @type {string}
  ###
  @random: do ->
    x = 2147483648
    Math.floor(Math.random() * x).toString(36) +
    Math.abs(Math.floor(Math.random() * x) ^ goog.now()).toString(36)

  ###*
    @type {string}
    @protected
  ###
  source: ''

  ###*
    @type {string}
    @protected
  ###
  random: ''

  ###*
    @type {Array}
    @protected
  ###
  replaces: null

  ###*
    @return {string}
  ###
  fixClass: ->
    original = @source

    @storeReplaces()
    lastState = null

    loop
      className = @getClassName()
      break if !className || lastState == @source
      lastState = @source

      superClass = @getSuperClass className

      if superClass
        @removeCoffeeExtends className
        @removeInjectedExtendsCode className
      else
        @removeClassVar className

      namespace = @getNamespaceFromWrapper className
      @fullQualifyProperties className, namespace
      @fullQualifyConstructor className, namespace
      @fullQualifyNew className, namespace

      if superClass
        @addGoogInherits className, namespace, superClass
        @fixSuperClassReference className, namespace

      @removeWrapper className, namespace, superClass

    @restoreReplaces()
    if original != @source
      @source = "// Coffe Class fixed for Closure Compiler by Este.js\n" + @source
    @source

  ###*
    @return {string|undefined}
  ###
  getClassName: ->
    @source.match(/function ([A-Z][\w]*)/)?[1]

  ###*
    @param {string} className
    @return {string}
  ###
  getSuperClass: (className) ->
    regex = new RegExp "return #{className};[\\s]*\\}\\)\\(([\\w\\.]+)\\);"
    matches = @source.match regex
    return '' if !matches
    matches[1]

  ###*
    @param {string} className
  ###
  removeCoffeeExtends: (className) ->
    regex = new RegExp "__extends\\(#{className}, _super\\);", 'g'
    @remove regex

  ###*
    @param {string} className
  ###
  removeInjectedExtendsCode: (className) ->
    @remove """
      var #{className},
        __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };"""

    @remove """
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };"""

  ###*
    @param {string} className
  ###
  removeClassVar: (className) ->
    regex = new RegExp "var #{className};", 'g'
    @remove regex

  ###*
    @param {string|RegExp} value
    @protected
  ###
  remove: (value) ->
    @replace value, ''

  ###*
    @param {string|RegExp} value
    @param {string|Function} string
    @protected
  ###
  replace: (value, string) ->
    @source = @source.replace value, string

  ###*
    @param {string} className
    @return {string}
  ###
  getNamespaceFromWrapper: (className) ->
    regex = new RegExp "#{className} = \\(function\\((_super)?\\) \\{"
    index = @source.search regex
    return '' if index == -1
    letters = []
    while letter = @source.charAt --index
      break if letter in [' ', ';', '\n']
      letters.unshift letter
    letters.join ''

  ###*
    @param {string} className
    @param {string} namespace
  ###
  fullQualifyProperties: (className, namespace) ->
    regex = new RegExp className + '\\.(\\w+)', 'g'
    @replace regex, (match, prop, offset) =>
      return match if /[\.\w]/.test @source.charAt(offset - 1)
      return match if prop in [className, '__super__']
      namespace + match

  ###*
    @param {string} className
    @param {string} namespace
  ###
  fullQualifyConstructor: (className, namespace) ->
    regex = new RegExp "function #{className}", 'g'
    if namespace
      @replace regex, namespace + className + ' = function'
    else
      @replace regex, 'var ' + className + ' = function'

  ###*
    @param {string} className
    @param {string} namespace
  ###
  fullQualifyNew: (className, namespace) ->
    regex = new RegExp "new #{className}", 'g'
    @replace regex, "new #{namespace}#{className}"

  ###*
    @param {string} className
    @param {string} namespace
    @param {string} superClass
    @protected
  ###
  addGoogInherits: (className, namespace, superClass) ->
    # match begin of constructor
    regex = new RegExp "#{namespace}#{className} = function\\(", 'g'
    index = @source.search regex
    return if index == -1

    # Looking for position after constructor, is a bit tricky, because function
    # can contains everything. Luckily, indentation works for us.
    lines = @source.slice(index).split '\n'

    # handle empty constructors
    endsWith = (str, suffix) ->
      l = str.length - suffix.length
      l >= 0 && str.indexOf(suffix, l) == l

    if endsWith lines[0], ') {}'
      index += lines[0].length + 1
    else
      for line, i in lines
        index += line.length + 1
        break if line == '  }'

    inherits = "\n  goog.inherits(#{namespace + className}, #{superClass});\n"
    @source = @source.slice(0, index) + inherits + @source.slice index

  ###*
    @param {string} className
    @param {string} namespace
    @protected
  ###
  fixSuperClassReference: (className, namespace) ->
    regex = new RegExp "#{className}\\.__super__", 'g'
    @replace regex, "#{namespace}#{className}\.superClass_"

  ###*
    @param {string} className
    @param {string} namespace
    @param {string} superClass
  ###
  removeWrapper: (className, namespace, superClass) ->
    # intro
    regex = new RegExp "#{namespace}#{className} = \\(function\\((_super)?\\) \\{"
    @remove regex
    # outro
    regex = new RegExp "return #{className};[\\s]*\\}\\)\\((#{superClass})?\\);", 'g'
    @remove regex

  ###*
    Ugly as sin workaround.
    TODO: use esprima
    @protected
  ###
  storeReplaces: ->
    @source = @source.replace /\$/g, (match) =>
      "xn2fs07c6n7ldollar_sucks_for_regexps"

    # http://blog.stevenlevithan.com/archives/match-quoted-string
    @source = @source.replace /(["'])(?:(?=(\\?))\2.)*?\1/g, (match) =>
      "#{CoffeeForClosure.random}#{@replaces.push match}#{CoffeeForClosure.random}"

    @source = @source.replace /\/\*[^*]*\*+([^\/][^*]*\*+)*\//g,
      (match) => "#{CoffeeForClosure.random}#{@replaces.push match}#{CoffeeForClosure.random}"

  ###*
    @protected
  ###
  restoreReplaces: ->
    l = @replaces.length
    while l--
      replace = @replaces[l]
      @source = @source.replace "#{CoffeeForClosure.random}#{l + 1}#{CoffeeForClosure.random}", replace
    @source = @source.replace /xn2fs07c6n7ldollar_sucks_for_regexps/g,
      (match) => "$"
    return

###*
  @param {string} source
###
este.dev.coffeeForClosure = (source) ->
  coffeeForClosure = new este.dev.CoffeeForClosure source
  coffeeForClosure.fixClass()

# just for sake of the Compiler
exports = exports || {}
exports.coffeeForClosure = este.dev.coffeeForClosure