$ = require 'jquery'

setupCode = require './setup-code'
checkProof = require './check-proof'
getData = require './get-data'
showExercise = require './show-exercise'
brag = require './brag'
#require './vendor/jquery.scrollintoview'

module.exports = (exerciseNumber) ->
	codePromise = setupCode()

	showDocument = (code) ->
		($ '.hid').hide()


		#for x in [ '#brag', '#code', '#checkResultContainer', '#hint' ]
		#	($ x).hide()

		($ '#cover').fadeOut 300, ->
			($ @).remove()

		click = (buttonId, respond) ->
			(($ buttonId).unbind 'click').click respond

		click '#checkButton', ->
			checkProof code

		click '#bragButton', ->
			($ '#brag').slideToggle()

		click '#hintButton', ->
			($ '#hint').slideToggle()

		click '#startProof', ->
			# scroll to top
			($ 'body').animate scrollTop: 0,
				complete: ->
					code.show()

		click '#checkResultContainer', ->
			($ '#checkResultContainer').slideUp()

		($ '#bragForm').submit (event) ->
			event.preventDefault()
			brag code

	# Load the exercise.
	($.when (getData "#{exerciseNumber}"), codePromise).then (exercise, code) ->
		exercise.number = exerciseNumber
		showExercise code, exercise
		showDocument code
	.fail (err) ->
		window.alert "Could not load exercise #{exNum}"

