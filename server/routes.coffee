brag = require './brag'
{ allExercises } = require './all-exercises'

module.exports =
	index: (req, res) ->
		res.render 'index',
			allExercises: allExercises
			keyCodes:
				# These should match assets/script/lol-deduce-mode
				[
					[ '^', '∧', 'and' ],
					[ 'V', '∨', 'or' ],
					[ '-', '¬', 'not' ],
					[ '>', '→', 'implies' ],
					[ '*', '⊕', 'xor' ],
					[ ':', '⇒', 'rule body' ]
				]

	exercise: (req, res) ->
		res.render 'exercise'

	brag: (req, res) ->
		brag req.body, res

	free: (req, res) ->
		res.render 'free'
