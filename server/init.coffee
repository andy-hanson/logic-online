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

exports.app = (app) ->
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

exports.router = (app) ->
	exerciseRouter = express.Router()
	exerciseRouter.post '/brag', routes.brag

	params.extend exerciseRouter
	exerciseRouter.param 'exerciseNumber', Number
	exerciseRouter.get '/:exerciseNumber', (req, res) ->
		res.render 'exercise.jade'

	app.use '/exercise', exerciseRouter

	app.get '/', routes.index
	app.get '/free', routes.free
