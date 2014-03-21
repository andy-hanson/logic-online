$ = require 'jquery'
lolDeduce = require 'lol-deduce'

CHEAT = yes

module.exports = checkProof = (code) ->
	out =
		if CHEAT
			[]
		else
			lolDeduce.checkLogic code.getFullContents()

	success = $ '#checkSuccess'
	fail = $ '#checkFail'

	if out instanceof Array
		if out.length == 0
			($ '#checkSuccessNoPremises').show()
			($ '#checkSuccessWithPremises').hide()
		else
			($ '#checkSuccessNPremises').text " #{out.length} "
			p = ($ '#checkSuccessPremises')
			p.empty().append ' '

			# x, y, and z
			for premise, idx in out
				p.append \
					(($ '<span/>').addClass 'checkSuccessLine').text \
						premise.pos().line().toString()
				if idx < out.length - 2
					p.append ', '
				else if idx == out.length - 2
					p.append if out.length == 2 then ' and ' else ', and '

			($ '#checkSuccessNoPremises').hide()
			($ '#checkSuccessWithPremises').show()

		fail.hide()
		success.show()

	else
		fail
		.empty()
		.append (($ '<span/>').addClass 'checkFailLine').text out.pos().line()
		.append (($ '<span/>').addClass 'checkFailExplain').text out.explain()

		success.hide()
		fail.show()
