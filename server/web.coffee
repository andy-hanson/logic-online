express = require 'express'
init = require './init'

app = express()
init app

app.listen (app.get 'port'), ->
	console.log
		port: app.get 'port'
		mode: app.settings.env
