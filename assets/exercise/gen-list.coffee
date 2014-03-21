#! /usr/bin/env coffee
fs = require 'fs'
path = require 'path'
yaml = require 'yamljs'

{ allExercises } = require '../../server/all-exercises'

list = { }
allExercises.forEach (exercise) ->
	list[exercise.index] = exercise.title

fs.writeFileSync (path.join __dirname, 'list.yaml'), yaml.stringify list
