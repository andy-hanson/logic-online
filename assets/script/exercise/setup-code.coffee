$ = require 'jquery'
docReady = require '../doc-ready'
makeCodeMirror = require '../make-code-mirror'

module.exports = setupCode = ->
	docReady().then ->
		code =
			setup: makeCodeMirror ($ '#setup'),
				readOnly: yes
			editor: makeCodeMirror ($ '#editor')
			finish: makeCodeMirror ($ '#finish'),
				readOnly: yes

		# Line numbers set in show-exercise.
		# This ensures that finish updates
		# its line numbers whenever editor embiggens.
		code.editor.on 'change', ->
			code.finish.refresh()

		code.getEditorContent = ->
			code.editor.getValue()

		code.getFullContents = ->
			code.setup.getValue() + '\n' +
			code.editor.getValue() + '\n' +
			code.finish.getValue()

		code.slideAndShow = ->
			($ '#code').slideDown()
			code.editor.refresh()
			code.editor.focus()
			code.finish.refresh()

		code
