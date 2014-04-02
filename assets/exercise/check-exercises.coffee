#! /usr/bin/env coffee
{ checkExercise } = require 'lol-deduce'
{ allExercises } = require '../../server/all-exercises'

for name, exercise of allExercises
	#console.log exercise.title
	if (err = checkExercise exercise.setup, exercise.answer, exercise.finish)?
		console.log "Exercise #{exercise.title}: #{err}"
		return

console.log '✔'
