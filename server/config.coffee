fs = require 'fs'
path = require 'path'
yaml = require 'yamljs'

env = (name) ->
	process.env[name] ?
		throw Error 'Need config.yaml or environment variable #{name}'

module.exports = do ->
	cfg = path.join __dirname, './config.yaml'
	if fs.existsSync cfg
		yaml.parse fs.readFileSync cfg, 'utf8'
	else
		appname: 'logic-online'
		port: env 'PORT'
		email:
			from: env 'EMAIL_FROM'
			service: env 'EMAIL_SERVICE'
			auth:
				user: env 'EMAIL_USERNAME'
				pass: env 'EMAIL_PASSWORD'