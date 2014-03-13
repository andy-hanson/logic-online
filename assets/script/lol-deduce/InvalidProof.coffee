{ type } = require './help/✔'
{ read } = require './help/meta'
Pos = require './Pos'

module.exports = class InvalidProof extends Error
	constructor: (@_pos, @_explain) ->
		type @_pos, Pos, @_explain, String
		@message = "#{@_pos}: #{@_explain}"

	read @, 'pos', 'explain'
