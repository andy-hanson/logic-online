fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'

withoutEnd = (str, end) ->
	str.slice 0, str.length - end.length

allExercises = {}

dir =
	path.join __dirname, '../assets/exercise'

order =
	(fs.readFileSync (path.join dir, 'Order'), 'utf-8').trim().split '\n'

for name, index in order
	text =
		fs.readFileSync (path.join dir, "#{name}.yaml"), 'utf-8'
	mangledIndents =
		text.replace /\n\t/g, '\n  '
	exercise =
		yaml.safeLoad mangledIndents
	exercise.name = name
	exercise.index = index

	allExercises[name] = exercise


module.exports =
	allExercises: allExercises

	getExercise: (name) ->
		allExercises[name] ? throw new Error "Bad exercise name: #{name}"
