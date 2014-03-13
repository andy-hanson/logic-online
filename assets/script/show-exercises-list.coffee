$ = require 'jquery'
getData = require './get-data'

haveShown = false

module.exports = ->
	($ '#exercises').toggle()

	unless haveShown
		haveShown = yes
		(getData "exercise/list").then (data) ->
			table = $ '#exercisesTable'

			(Object.keys data).forEach (number) ->
				description = data[number]

				num = $ '<td/>'
				num.append ($ "<a href=##{number}>").text number
				num.addClass 'exerciseNumber'

				desc = (($ '<td/>').addClass 'exerciseDescription').text description

				ex = $ '<tr/>'
					.append num
					.append desc

				table.append ex
