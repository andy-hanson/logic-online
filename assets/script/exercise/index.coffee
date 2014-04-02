$ = require 'jquery'

getData = require '../get-data'
setupCode = require './setup-code'
checkProof = require './check-proof'
showExercise = require './show-exercise'
brag = require './brag'

module.exports = (exerciseName) ->
	codePromise = setupCode()

	showDocument = (code) ->
		($ '.hid').hide()

		($ '#cover').fadeOut 300, ->
			($ @).remove()

		($ '#checkButton').click ->
			code.slideAndShow()
			checkProof code

		($ '#checkResultContainer').click ->
			($ '#checkResultContainer').slideUp()

		($ '#bragButton').click ->
			($ '#brag').slideToggle()

		($ '#hintButton').click ->
			($ '#hint').slideToggle()

		($ '#startProof').click ->
			# scroll to top
			($ 'body').animate scrollTop: 0,
				complete: ->
					code.slideAndShow()

		($ '#bragForm').submit (event) ->
			event.preventDefault()
			brag code

	# Load the exercise.
	($.when (getData "#{exerciseName}"), codePromise).then (exercise, code) ->
		exercise.name = exerciseName

		for x in [ 'setup', 'answerSetup', 'finish' ]
			if exercise.hasOwnProperty x
				exercise[x] = exercise[x].trim()

		code.exercise = exercise
		showExercise code
		showDocument code
	.fail (err) ->
		window.alert "Could not load exercise #{exerciseName}"

