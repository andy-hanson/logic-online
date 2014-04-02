$ = require 'jquery'

docReady = require './doc-ready'
exercise = require './exercise'
free = require './free'

last = (arr) ->
	arr[arr.length - 1]

end =
	last window.location.href.split '/'

switch
	when res = /.*\/exercise\/(.+)/.exec window.location.href
		exercise res[1]
	when end == 'free'
		free()
	when end == '' # index
		docReady().then ->
			($ '#cover').hide()
	else
		throw new Error "Unexpected URL: '#{end}'"

