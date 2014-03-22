$ = require 'jquery'
markdown = require 'marked'

module.exports = showExercise = (code, exercise) ->
	($ '#explainText').html markdown exercise.explain
	($ '#hintText').html markdown exercise.hint
	($ '#exerciseNumber').text exercise.number
	($ '#exerciseTitle').text exercise.title

	nextExerciseNumber = parseInt(exercise.number) + 1
	($ '#nextExercise').attr 'href', "./#{nextExerciseNumber}"
	($ '#nextExerciseNumber').text nextExerciseNumber

	code.setup.setValue exercise.setup.trim()
	code.editor.setValue ''
	code.finish.setValue exercise.finish.trim()

	setupNLines = code.setup.lineCount()

	code.editor.setOption 'firstLineNumber', setupNLines + 1
	code.finish.setOption 'lineNumberFormatter', (line) ->
		'' + (line + setupNLines + code.editor.lineCount())

