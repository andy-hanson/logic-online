express = require 'express'
path = require 'path'
injector = require 'render-options-injector'
compress = require 'compression'
errorHandler = require 'errorhandler'
morgan = require 'morgan'
bodyParser = require 'body-parser'
params = require 'express-params'

routes = require './routes'
config = require './config'

module.exports = (app) ->
	rootPath = process.cwd()

	app.set 'port', config.port
	app.set 'views', path.join rootPath, 'assets/view'
	app.set 'view engine', 'jade'

	app.use morgan 'tiny'
	app.use compress()
	app.use express.static path.join rootPath, 'public'
	app.use bodyParser()

	app.use errorHandler
		dumpExceptions: yes
		showStack: yes

	injector.inject app,
		env: app.settings.env

	# Routing

	app.get '/', routes.index
	app.post '/brag', routes.brag
	app.get '/free', routes.free

	params.extend app
	app.param 'exerciseName', String
	app.get '/exercise/:exerciseName', (req, res) ->
		res.render 'exercise.jade'
