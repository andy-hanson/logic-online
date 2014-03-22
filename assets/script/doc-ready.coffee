$ = require 'jquery'

module.exports = ->
	docReady = $.Deferred()
	($ document).ready docReady.resolve
	docReady
