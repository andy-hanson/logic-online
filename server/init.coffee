express = require 'express'
path = require 'path'
injector = require 'render-options-injector'
compress = require 'compression'
errorHandler = require 'errorhandler'
morgan = require 'morgan'
bodyParser = require 'body-parser'

routes = require './routes'
config = require './config'

exports.app = (app) ->
	rootPath = process.cwd()

	app.set 'port', config.port
	app.set 'views', path.join rootPath, 'views'
	app.set 'view engine', 'jade'

	# app.use express.methodOverride()
	app.use morgan 'tiny'
	app.use compress()
	app.use express.static path.join rootPath, 'public'
	app.use bodyParser()

	app.use errorHandler
		dumpExceptions: yes
		showStack: yes

	injector.inject app,
		env: app.settings.env

exports.router = (app) ->
	app.get '/', routes.index
	app.post '/brag', routes.brag
