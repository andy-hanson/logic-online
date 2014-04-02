$ = require 'jquery'
yaml = require 'js-yaml'

module.exports = getData = (name, callBack) ->
	($.ajax "#{name}.yaml").then (text) ->
		mangledIndents = text.replace /\n\t/g, '\n  '
		yaml.safeLoad mangledIndents
