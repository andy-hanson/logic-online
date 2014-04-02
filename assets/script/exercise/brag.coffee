$ = require 'jquery'

module.exports = (code) ->
	($ '#bragSubmit').attr 'disabled', yes
	($ '#bragSuccess').slideUp()
	($ '#bragFail').slideUp()

	data =
		userName: ($ '#userName').val()
		emailFrom: ($ '#emailFrom').val()
		emailTo: ($ '#emailTo').val()
		exerciseName: code.exercise.name
		solution: code.editor.getValue()
		comment: ($ '#comment').val().trim()

	$.post '/brag', data, (response) ->
		if response.success
			($ '#bragSuccess').slideDown()
		else
			(($ '#bragFail').text response.explain).slideDown()

		($ '#bragSubmit').attr 'disabled', no
