module.exports = (grunt) ->
	grunt.initConfig
		pkg:
			grunt.file.readJSON 'package.json'

		browserify:
			dev:
				files:
					'public/script/index.js':
						[ 'assets/script/index.coffee' ]
				options:
					extensions: [ '.js', '.coffee' ]
					transform: [ 'coffeeify', 'uglifyify' ]
					#debug: yes # enables source maps

		clean:
			all: [ 'doc', 'node_modules', 'public' ]
			pre: [ 'public' ]

		codo:
			options:
				inputs: [ 'assets/script' ]
				output: 'doc'

		coffeelint:
			app: [ 'assets/script/**/*.coffee' ]
			options:
				camel_case_classes:
					level: 'error'
				indentation:
					value: 1
					level: 'error'
				max_line_length:
					value: 80
					level: 'error'
				no_plusplus:
					level: 'error'
				no_tabs:
					level: 'ignore'
				no_throwing_strings:
					level: 'error'
				no_trailing_semicolons:
					level: 'error'
				no_trailing_whitespace:
					level: 'error'

		watch:
			options:
				livereload: no
			script:
				files: 'assets/script/**/*'
				tasks: [ 'browserify:dev' ]
			style:
				files: 'assets/style/**/*'
				tasks: [ 'stylus' ]
			image:
				files: 'assets/image/**/*'
				tasks: [ 'copy:image' ]
			exercise:
				files: 'assets/exercise/**/*'
				tasks: [ 'copy:exercise', 'exec:listExercises' ]

		stylus:
			files:
				expand: yes
				cwd: 'assets/style'
				src: [ '**/*.*' ]
				dest: 'public/style'
				ext: '.css'
			options:
				compress: yes
				linenos: yes
				firebug: yes

		copy:
			exercise:
				expand: yes
				cwd: 'assets/exercise'
				src: '**/*'
				dest: 'public/exercise'
			image:
				expand: yes
				cwd: 'assets/image/'
				src: '**/*'
				dest: 'public/image/'

		#exec:
			#dev:
			#	options:
			#		stdout: true
			#		stderr: true
			#	command: './node_modules/node-dev/bin/node-dev server/web.coffee'

		nodemon:
			dev:
				script: 'server/web.coffee'
				options:
					#ignore: 'assets' # don't need server reset for client assets
					watch: [ 'server' ]

		concurrent:
			dev:
				tasks: [ 'nodemon', 'watch' ]
				options:
					logConcurrentOutput: true

	(require 'load-grunt-tasks') grunt

	grunt.registerTask 'heroku:development', [
		'deploy-assets'
	]

	grunt.registerTask 'deploy-assets', [
		'clean:pre',
		'copy',
		'browserify',
		'stylus'
	]

	grunt.registerTask 'default', [
		'coffeelint',
		'codo',
		'deploy-assets',
		'concurrent:dev'
	]

	grunt.registerTask 'run', [
		'exec:dev'
	]
