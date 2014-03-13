Hi! I am logic-online!

To run the code, you'll need to write a file `server/config-email.coffee`.
Make it look like:

	module.exports =
		from: 'Other Logic Online <my.email@gmail.com>'
		service: 'Gmail'
		auth:
			user: 'my.email@gmail.com'
			pass: 'my-password'


