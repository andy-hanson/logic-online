#! /usr/bin/env coffee

{ checkExercise } = require 'lol-deduce'
{ allExercises } = require '../../server/all-exercises'

allExercises.forEach (exercise) ->
	if (err = checkExercise exercise.setup, exercise.answer, exercise.finish)?
		console.log exercise.title, err.toString()
