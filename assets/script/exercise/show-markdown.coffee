$ = require 'jquery'
markdown = require 'marked'
makeCodeMirror = require '../make-code-mirror'

module.exports = showMarkdown = (elementId, text) ->
	md = markdown text

	($ "##{elementId}").html markdown text

	($ "##{elementId} pre").replaceWith ->
		em = ($ '<div/>').addClass 'codeMirrorContainer'

		code =
			# marked replaces tabs with spaces. Undo that!
			($ @).text().trim().replace /\s\s\s\s/g, '\t'

		makeCodeMirror em,
			value: code
			lineNumbers: no
			readOnly: yes
		em

	#TODO: div ?
	($ "##{elementId} .codeMirrorContainer").each (it) ->
		(($ @).data 'codeMirror').refresh()
