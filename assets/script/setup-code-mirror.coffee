module.exports = setupCodeMirror = ->
	require './vendor/codemirror'
	require './vendor/matchbrackets'
	require './lol-deduce-mode'

	CodeMirror.defineMIME 'text/lol-deduce', 'lol-deduce'

	indentation = (str) ->
		index = 0
		while str[index] == '\t'
			index += 1
		str.slice 0, index

	means = (char) -> (cm) ->
		cm.replaceSelection char, 'end'

	indent = (indenter) -> (cm) ->
		indentAmount = indentation cm.getLine cm.getCursor().line
		cm.replaceSelection "#{indenter}\n\t#{indentAmount}", 'end'

	CodeMirror.keyMap['lol-deduce'] =
		'Alt-6': means '∧'
		'Alt-/': means '∨'
		'Alt--': means '¬'
		'Alt-.': means '→'
		'Alt-F': means '⊥'
		'Alt-;': indent '⇒'
		'Alt-=': indent '⇔'
		'Alt-A': means '∀'
		'Alt-E': means '∃'

		fallthrough: CodeMirror.keyMap.default
