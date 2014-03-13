module.exports =
	from: process.env.EMAIL_FROM
	service: process.env.EMAIL_SERVICE
	auth:
		user: process.env.USERNAME
		pass: process.env.PASSWORD
