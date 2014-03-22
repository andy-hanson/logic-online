CodeMirror.defineMIME 'text/lol-proof', 'lol-proof'

indentation = (str) ->
	index = 0
	while str[index] == '\t'
		index += 1
	return str.slice 0, index

means = (char) -> (cm) ->
	cm.replaceSelection char, 'end'

CodeMirror.keyMap['lol-deduce'] =
	'Ctrl-Alt-6': means '∧'
	'Ctrl-Alt-v': means '∨'
	'Ctrl-Alt--': means '¬'
	'Ctrl-Alt-.': means '→'
	'Ctrl-Alt-,': means '←'
	'Ctrl-Alt-8': means '⊕'
	'Ctrl-Alt-A': means '∀'
	'Ctrl-Alt-E': means '∃'
	'Ctrl-Alt-;': (cm) ->
		indent = indentation cm.getLine cm.getCursor().line
		cm.replaceSelection "⇒\n\t#{indent}", 'end'

	fallthrough: CodeMirror.keyMap.default


CodeMirror.defineMode 'lol-deduce', (config, parserConfig) ->
	indentAmount = 4

	keywords = [ 'declare', '⇒' ]

	# styles defined in codemirror.css; we remove 'cm-' prefix
	style =
		'⇒': 'keyword'
		badChar: 'invalidchar'
		colon: 'bracket'
		comma: 'bracket'
		comment: 'comment'
		declare: 'header'
		indentError: 'error'
		justification: 'tag'
		label: 'def'
		name: 'variable' # 'atom'
		operator: 'variable-3'
		paren: 'bracket'
		rule: 'def'
		space: 'positive'


	token: (stream) ->
		keyword = ->
			style[stream.current()]

		atLineStart = stream.sol()
		stream.eatWhile /\s/

		if stream.eol()
			null
		else if stream.indentation() % 4 != 0
			stream.skipToEnd()
			style.indentError
		else if stream.match /.*:/, yes
			style.label
		else if stream.eatWhile /[%^&*\-+=<>\.\/\?∨∧¬→↔⊕]/
			if stream.current() in keywords
				keyword()
			else
				style.operator
		else if stream.eatWhile /[A-Za-z0-9]/
			if stream.current() in keywords
				keyword()
			else
				style.name
		else if stream.eat ':'
			style.colon
		else if stream.eatWhile /\s/
			style.space
		else if stream.eat /\|/
			stream.skipToEnd()
			style.justification
		else if stream.eat /,/
			style.comma
		else if stream.eat /[\(\)]/
			style.paren
		else if stream.eat /\\/
			stream.skipToEnd()
			style.comment
		else
			stream.skipToEnd()
			style.badChar

	lineComment: '\\'
