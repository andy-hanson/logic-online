$ = require 'jquery'
setupCodeMirror = require './setup-code-mirror'

module.exports = makeCodeMirror = (selector, extraOptions) ->
	setupCodeMirror()

	options =
		autoClearEmptyLines: yes
		indentUnit: 4
		indentWithTabs: yes
		keyMap: 'lol-deduce'
		lineNumbers: yes
		mode: 'lol-deduce'
		viewportMargin: Infinity

	$.extend options, extraOptions

	domEm = selector.get 0

	cm = CodeMirror domEm, options

	selector.data 'codeMirror', cm

	cm
