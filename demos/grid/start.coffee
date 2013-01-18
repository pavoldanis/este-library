###*
  @fileoverview este.demos.grid.start
###

goog.provide 'este.demos.grid.start'

goog.require 'este.Collection'
goog.require 'este.demos.Grid'
goog.require 'este.Model'

este.demos.grid.start = ->

  columns =
    id: 'ID'
    title: 'Title'
    duration: 'Duration'
    percentComplete: 'Percent Complete'
    start: 'Start'
    finish: 'Finish'
    effortDriven: 'Effort Driven'

  rowsData = for i in [0...20]
    id: i
    title: 'Task ' + i
    duration: '5 days'
    percentComplete: Math.round Math.random() * 100
    start: '01/01/2009'
    finish: '01/05/2009'
    effortDriven: i % 5 == 0

  rows = new este.Collection rowsData
  grid = new este.demos.Grid columns, rows
  grid.render document.body