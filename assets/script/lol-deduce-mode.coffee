lolDeduce = require 'lol-deduce'

CodeMirror.defineMode 'lol-deduce', (config, parserConfig) ->
	# styles defined in codemirror.css; we remove 'cm-' prefix
	style =
		'⇒': 'keyword'
		'⇔': 'keyword'
		assert: 'header'
		badChar: 'invalidchar'
		colon: 'bracket'
		comma: 'bracket'
		comment: 'comment'
		declare: 'header'
		#indentError: 'error'
		justification: 'tag'
		label: 'def'
		name: 'variable' # 'atom'
		operator: 'variable-3'
		paren: 'bracket'
		rule: 'def'
		#space: 'positive' # never triggered

	token: (stream) ->
		atLineStart = stream.sol()
		stream.eatWhile /\s/

		if stream.match /assert [^:]*/
			style.assert
		else if stream.eat ':'
			style.colon
		else if stream.match /.+:/
			stream.backUp 1
			style.label
		else if (stream.eatWhile lolDeduce.language.char.operator) or stream.eat '¬'
			style.operator
		else if stream.eatWhile lolDeduce.language.char.name
			if stream.current() == 'declare'
				style.declare
			else
				style.name
		else if stream.eat /[⇒⇔]/
			style[stream.current().trim()]
		#else if stream.eatWhile /\s/
		#	style.space
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
