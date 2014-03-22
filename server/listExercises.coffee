###
yaml = require 'yamljs'

{ allExercises } = require './all-exercises'

list = { }
allExercises.forEach (exercise) ->
	list[exercise.index] = exercise.title

listJson = yaml.stringify list

module.exports = (req, res) ->
	res.write listJson
	res.end()
###
