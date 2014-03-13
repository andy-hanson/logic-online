path = require 'path'
emailTemplates = require 'email-templates'
nodeMailer = require 'nodemailer'
yaml = require 'yamljs'
lolDeduce = require '../assets/script/lol-deduce'

templatesDir = path.join __dirname, 'email-templates'

#emailInfo = require './config-email'

transport = nodeMailer.createTransport# 'SMTP', emailInfo

fs = require 'fs'

exercises = []

for idx in [1..3]
	loc = path.join __dirname, "../assets/exercise/#{idx}.yaml"
	text = fs.readFileSync loc, 'utf8'
	mangledIndents = text.replace /\n\t/g, '\n  '
	exercises[idx] = yaml.parse mangledIndents


getExercise = (num) ->
	exercises[parseInt num] ? throw new Error "Bad exercise number: #{n}"



###
userName: 'Andy'
emailTo: 'hansoa2@rpi.edu'
exerciseNum: 1
solution: 'solution goes here'
comment: 'comment goes here'
###

module.exports = brag = (bragData, res) ->

	exercise = getExercise bragData.exerciseNumber

	checkRes = lolDeduce.checkExercise exercise.setup, bragData.solution, exercise.finish

	msg = (x) ->
		res.send x
		res.end()

	if checkRes instanceof lolDeduce.InvalidProof
		msg
			success: no
			explain: checkRes.message # TODO: line no. too

	else
		emailTemplates templatesDir, (err, template) ->
			if err?
				msg
					success: no
					explain: "There was a problem emailing: #{err.message}"

			else
				###
				bragData.exerciseURL =
					"http://logic-online.herokuapp.com/##{bragData.exerciseNumber}"

				template 'exercise-completed', bragData, (err, html, text) ->
					throw err if err?

					(require 'fs').writeFileSync './server/TEST_EMAIL', html

					transport.sendMail
						from: emailInfo.from
						to: bragData.emailTo
						subject:
							"[Logic Online] #{bragData.userName} completed " +
							"exercise #{bragData.exerciseNumber}"
						html: html
						generateTextFromHtml: yes
					, (err, responseStatus) ->
						throw err if err?
						console.log responseStatus.message
				###

				msg
					success: yes

