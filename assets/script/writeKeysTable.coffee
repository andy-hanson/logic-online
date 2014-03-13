###
This should match what's in lol-deduce-mode.
###

$ = require 'jquery'

module.exports = writeKeysTable = ->
	keysTable = $ '#aboutKeys'

	if keysTable.is ':empty'

		console.log keysTable.is ':empty'

		keys = [
			[ '^', '∧', 'and' ],
			[ 'V', '∨', 'or' ],
			[ '-', '¬', 'not' ],
			[ '>', '→', 'implies' ],
			[ '<', '←', 'implied-by' ],
			[ '*', '⊕', 'xor' ],
			[ ':', '⇒', 'rule body' ],
			[ 'C', '✔', 'check' ]
		]

		for [ key, result, explain ] in keys
			tr = $ '<tr/>'
			td = (text) ->
				($ '<td/>').text text
			tr
			.append (td key).addClass 'key'
			.append (td result).addClass 'key'
			.append (td explain)

			keysTable.append tr
