brag = require './brag'

module.exports =
	index: (req, res) ->
		res.render 'index'
	brag: (req, res) ->
		brag req.body, res
