fs = require 'fs'
path = require 'path'
yaml = require 'yamljs'

allExercises = []

nExercises = 3

for index in [1..nExercises]
	loc =
		path.join __dirname, "../assets/exercise/#{index}.yaml"
	text =
		fs.readFileSync loc, 'utf8'
	mangledIndents =
		text.replace /\n\t/g, '\n  '
	exercise =
		yaml.parse mangledIndents
	exercise.index =
		index
	allExercises[index] = exercise


module.exports =
	allExercises: allExercises

	getExercise: (num) ->
		allExercises[parseInt num] ? throw new Error "Bad exercise number: #{n}"
