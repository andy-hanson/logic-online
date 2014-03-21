emailTemplates = require 'email-templates'
nodeMailer = require 'nodemailer'
path = require 'path'
lolDeduce = require 'lol-deduce'

templatesDir = path.join __dirname, 'email-templates'

emailInfo = (require './config').email

transport = nodeMailer.createTransport 'SMTP', emailInfo

{ getExercise } = require './all-exercises'


###
@param bragData [{ userName, emailTo, exerciseNum, solution, comment }]
###

module.exports = brag = (bragData, res) ->
	exercise = getExercise bragData.exerciseNumber

	checkRes = lolDeduce.checkExercise exercise.setup, bragData.solution, exercise.finish

	msg = (content) ->
		res.send content
		res.end()
	nuts = (error) ->
		if error?
			console.log error
			msg
				success: no
				explain: "There was a problem emailing: #{error}"

	if checkRes instanceof lolDeduce.InvalidProof
		msg
			success: no
			explain: checkRes.message # TODO: line no. too

	else
		emailTemplates templatesDir, (err, template) ->
			nuts err

			bragData.exerciseURL =
				"http://logic-online.herokuapp.com/##{bragData.exerciseNumber}"

			template 'exercise-completed', bragData, (err, html, text) ->
				nuts err

				console.log emailInfo

				transport.sendMail
					from: emailInfo.from
					to: bragData.emailTo
					subject:
						"[Logic Online] #{bragData.userName} completed " +
						"exercise #{bragData.exerciseNumber}"
					html: html
					generateTextFromHtml: yes
				, (err, responseStatus) ->
					nuts err
					console.log responseStatus.message

					msg
						success: yes

