$ = require 'jquery'
yaml = require 'yamljs'

module.exports = getData = (name, callBack) ->
	($.ajax "#{name}.yaml").then (text) ->
		mangledIndents = text.replace /\n\t/g, '\n  '
		yaml.parse mangledIndents
