brag = require './brag'
{ allExercises } = require './all-exercises'
keyCodes = require './key-codes'

module.exports =
	index: (req, res) ->
		res.render 'index',
			allExercises: allExercises
			keyCodes: keyCodes

	exercise: (req, res) ->
		res.render 'exercise'

	brag: (req, res) ->
		brag req, res

	free: (req, res) ->
		res.render 'free'
