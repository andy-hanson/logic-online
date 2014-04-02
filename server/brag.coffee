emailTemplates = require 'email-templates'
nodeMailer = require 'nodemailer'
path = require 'path'
validator = require 'validator'
q = require 'q'
lolDeduce = require 'lol-deduce'
{ getExercise } = require './all-exercises'

emailInfo = (require './config').email
transport = nodeMailer.createTransport 'SMTP', emailInfo

templatesDir = path.join process.cwd(), 'assets/email-templates'


###
@param bragData [{
	userName, emailFrom, emailTo, exerciseName, solution, comment }]
###

module.exports = brag = (req, res) ->
	bragData = req.body

	exercise = getExercise bragData.exerciseName

	bragData.exerciseURL =
		"#{req.protocol}://#{req.get 'host'}/exercise/#{bragData.exerciseName}"

	checkRes =
		lolDeduce.checkExercise exercise.setup, bragData.solution, exercise.finish

	checkEmail = (email) ->
		unless ok = validator.isEmail email
			res.send
				success: no
				explain: "Not an email address: #{email}"
		ok

	unless (checkEmail bragData.emailFrom) and checkEmail bragData.emailTo
		null # done

	else if checkRes instanceof lolDeduce.InvalidProof
		res.send
			success: no
			explain: "Bad proof: #{checkRes.toString()}"

	else
		emailPromise = (opts) ->
			q.ninvoke transport, 'sendMail',
				from: opts.from
				to: opts.to
				subject: opts.subject
				html: opts.html
				generateTextFromHtml: yes

		(q.nfcall emailTemplates, templatesDir)
		.then (template) ->
			q.nfcall template, 'exercise-completed', bragData
		.then (htmlAndText) ->
			html = htmlAndText[0]

			emailPromise
				from: bragData.emailFrom
				to: bragData.emailTo
				subject:
					"[Logic Online] #{bragData.userName} completed " +
					"exercise #{bragData.exerciseName}"
				html: html
			html
		.then (html) ->
			emailPromise
				from: emailInfo.from
				to: bragData.emailFrom
				subject:
					"[Logic Online] You bragged to #{bragData.emailTo}"
				html: html
		.then ->
			res.send
				success: yes
		.fail (error) ->
			console.log error
			res.send
				success: no
				explain: "There was a problem emailing: #{error}"
