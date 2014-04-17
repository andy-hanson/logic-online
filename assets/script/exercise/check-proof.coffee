$ = require 'jquery'
lolDeduce = require 'lol-deduce'

module.exports = checkProof = (code) ->
	($ '#checkResultContainer').slideDown()

	out =
		lolDeduce.checkExercise \
			code.exercise.setup,
			code.getEditorContent(),
			code.exercise.finish

	success = $ '#checkSuccess'
	fail = $ '#checkFail'

	if out instanceof lolDeduce.InvalidProof
		fail
		.empty()
		.append (($ '<span/>').addClass 'checkFailLine').text out.pos().line()
		.append (($ '<span/>').addClass 'checkFailExplain').text out.explain()

		success.hide()
		fail.show()

	else
		fail.hide()
		success.show()
