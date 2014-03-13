{ type } = require './help/✔'
compile = require './compile'
checkLogic = require './checkLogic'
InvalidProof = require './InvalidProof'

module.exports =
	compile: compile

	InvalidProof: InvalidProof

	#checkLogic: (str) ->
	#	type str, String
	#	compile str
		# checkLogic compile str

	###
	@return [InvalidProof, Array]
	###
	checkLogic: (str) ->
		type str, String
		try
			checkLogic compile str
		catch error
			if error instanceof InvalidProof
				error
			else
				throw error

	###
	@return [InvalidProof?]
	###
	checkExercise: (setup, answer, finish) ->
		text = "#{setup}\n#{answer}\n#{finish}"
		setupEnd = (setup.split '\n').length
		answerEnd = setupEnd + 1 + (answer.split '\n').length

		cl = module.exports.checkLogic text

		if cl instanceof Array
			for premise in cl
				lineNumber = premise.pos().line()
				if lineNumber >= setupEnd or lineNumber < answerEnd
					return new InvalidProof (new Pos lineNumber, 1),
						'Contains additional premise'
			null
		else
			cl

	###
	checkLogicString: (str) ->
		type str, String
		try
			premises = checkLogic compile str
			"Your #{premises.length} premises are: \n#{premises.join '\n'}"
		catch error
			if error instanceof InvalidProof
				return error.message
			else
				throw error
	###

	lex: require './compile/lex'
