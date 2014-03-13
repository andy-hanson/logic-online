$ = require 'jquery'
require './vendor/codemirror'
require './vendor/matchbrackets'
require './lol-deduce-mode'

docReady = $.Deferred()
($ document).ready docReady.resolve

module.exports = docReady.promise().then ->
	options =
		mode: 'lol-deduce'
		indentUnit: 4
		indentWithTabs: yes
		viewportMargin: Infinity
		lineNumbers: yes
		keyMap: 'lol-deduce'

	opts =
		editor: $.extend { autofocus: yes }, options
		nonEditable: $.extend { readOnly: yes }, options

	domEm = (name) ->
		($ "##{name}").get 0

	code =
		setup: CodeMirror (domEm 'setup'), opts.nonEditable
		editor: CodeMirror (domEm 'editor'), opts.editor
		finish: CodeMirror (domEm 'finish'), opts.nonEditable

	# Line numbers set in show-exercise.
	# This ensures that finish updates
	# its line numbers whenever editor embiggens.
	code.editor.on 'change', ->
		code.finish.refresh()

	code.getFullContents = ->
		code.setup.getValue() + '\n' +
		code.editor.getValue() + '\n' +
		code.finish.getValue()

	code
