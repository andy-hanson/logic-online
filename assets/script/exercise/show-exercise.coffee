$ = require 'jquery'
showMarkdown = require './show-markdown'

module.exports = showExercise = (code) ->
	ex = code.exercise

	console.log ex.explain

	showMarkdown 'explainText', ex.explain
	showMarkdown 'hintText', ex.hint
	($ '#exerciseTitle').text ex.title

	nextExerciseNumber = parseInt(ex.name) + 1
	($ '#nextExercise').attr 'href', "./#{nextExerciseNumber}"
	($ '#nextExerciseNumber').text nextExerciseNumber

	code.setup.setValue ex.setup
	if ex.answerSetup?
		code.editor.setValue ex.answerSetup
	code.finish.setValue ex.finish

	setupNLines = code.setup.lineCount()

	code.editor.setOption 'firstLineNumber', setupNLines + 1
	code.finish.setOption 'lineNumberFormatter', (line) ->
		'' + (line + setupNLines + code.editor.lineCount())

