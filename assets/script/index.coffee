$ = require 'jquery'

codePromise = require './setup-code'
checkProof = require './check-proof'
getData = require './get-data'
showExercise = require './show-exercise'
showExercisesList = require './show-exercises-list'
writeKeysTable = require './writeKeysTable'
brag = require './brag'

showDocument = (code) ->
	for x in [ '#about', '#brag', '.checkResult', '#exercises', '#hint' ]
		($ x).hide()

	($ '#cover').fadeOut 300, ->
		($ @).remove()

	click = (buttonId, respond) ->
		($ buttonId).unbind('click').click respond

	click '#checkButton', ->
		checkProof code

	click '#bragButton', ->
		($ '#brag').toggle()

	click '#aboutButton', ->
		writeKeysTable()
		($ '#about').toggle()

	click '#hintButton', ->
		($ '#hint').toggle()

	click '#exerciseButton', showExercisesList

	($ '#bragForm').submit (event) ->
		event.preventDefault()
		brag code

loadExercise = (exNum) ->
	($.when (getData "exercise/#{exNum}"), codePromise).then (exercise, code) ->
		exercise.number = exNum
		showExercise code, exercise
		showDocument code

window.onhashchange = ->
	# take off '#', exercise number is left
	loadExercise if location.hash == '' then 1 else location.hash.slice 1

window.onhashchange()

#($ document).ready ->
#	writeKeysTable()
