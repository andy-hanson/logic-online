$ = require 'jquery'
lolDeduce = require './lol-deduce'

module.exports = checkProof = (code) ->
	out = lolDeduce.checkLogic code.getFullContents()

	success = $ '#checkSuccess'
	fail = $ '#checkFail'

	if out instanceof Array
		($ '#checkSuccessNPremises').text " #{out.length} "
		p = ($ '#checkSuccessPremises')
		p.empty().append ' '

		# x, y, and z
		for premise, idx in out
			p.append \
				(($ '<span/>').addClass 'checkSuccessLine').text \
					premise.pos().line().toString()
			if idx < out.length - 2
				console.log '!!!'
				p.append ', '
			else if idx == out.length - 2
				p.append if out.length == 2 then ' and ' else ', and '

		fail.hide()
		success.show()

	else
		fail
		.empty()
		.append (($ '<span/>').addClass 'checkFailPos').text out.pos()
		.append (($ '<span/>').addClass 'checkFailExplain').text out.explain()

		success.hide()
		fail.show()
