$ = require 'jquery'
docReady = require './doc-ready'
makeCodeMirror = require './make-code-mirror'
lolDeduce = require 'lol-deduce'

generateResult = ->
	proof = (($ '#code').data 'codeMirror').getValue()
	res = lolDeduce.checkLogic proof
	if res instanceof Array
		($ '#result').text 'Correct!'
	else
		($ '#result').text res

showResult = ->
	generateResult()

	buttonsHeight = ($ '#buttons').outerHeight yes
	resHeight = ($ '#result').outerHeight yes
	console.log resHeight
	netHeight = buttonsHeight + resHeight

	($ '#result').slideDown()
	($ '#codeContainer').animate { top: netHeight }
	# code.css 'bottom', res.css 'height'

	(($ '#code').data 'codeMirror').refresh()


hideResult = (immediate = no) ->
	res = $ '#result'

	buttonsHeight = ($ '#buttons').outerHeight yes

	duration =
		if immediate == yes
			100
		else
			'default'

	res.slideUp duration
	($ '#codeContainer').animate { top: buttonsHeight }, duration

	(($ '#code').data 'codeMirror').refresh()


module.exports = ->
	docReady().then ->
		code = makeCodeMirror 'code',
			autofocus: yes


		($ '#checkButton').click showResult
		($ '#result').click hideResult
		hideResult yes

		($ '#cover').hide()

		loadFile = $ '#loadFile'
		($ '#loadButton').click ->
			loadFile.trigger 'click'

		loadFile.change (event) ->
			file = event.target.files[0]

			reader = new FileReader()
			reader.onload = (event) ->
				code.setValue event.target.result
			reader.readAsText file

		saveFile = $ '#saveFile'
		($ '#saveButton').click ->
			alert "For now, you'll have to copy and paste to a file yourself."
			# saveFile.trigger 'click'

		saveFile.change (event) ->
			file = event.target.files[0]

			writer = new FileWriter file

			# do work...





