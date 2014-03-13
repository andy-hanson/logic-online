$ = require 'jquery'

module.exports = (code) ->
	data =
		userName: ($ '#userName').val()
		emailTo: ($ '#emailTo').val()
		exerciseNumber: 1 # TODO
		solution: code.editor.getValue()
		comment: ($ '#comment').val().trim()

	$.post '/brag', data, (response) ->
		if response.success
			alert 'Your request has not been sent, because this feature is TODO.'
		else
			alert response.explain
