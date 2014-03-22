$ = require 'jquery'

docReady = require './doc-ready'
exercise = require './exercise'
free = require './free'

last = (arr) ->
	arr[arr.length - 1]

end =
	last window.location.href.split '/'

switch
	when /\d+/.test end
		exercise end
	when end == 'free'
		free()
	when end == '' # index
		docReady().then ->
			($ '#cover').hide()
	else
		throw new Error "Unexpected URL: '#{end}'"

