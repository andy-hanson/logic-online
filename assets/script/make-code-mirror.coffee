$ = require 'jquery'
setupCodeMirror = require './setup-code-mirror'

module.exports = (elementID, extraOptions) ->
	setupCodeMirror()

	options =
		mode: 'lol-deduce'
		indentUnit: 4
		indentWithTabs: yes
		viewportMargin: Infinity
		lineNumbers: yes
		keyMap: 'lol-deduce'

	if extraOptions?
		$.extend options, extraOptions

	domEm = (name) ->
		($ "##{name}").get 0

	element = $ "##{elementID}"

	cm = CodeMirror (element.get 0), options

	element.data 'codeMirror', cm

	cm
