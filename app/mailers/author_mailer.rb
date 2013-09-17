class AuthorMailer < MandrillMailer::TemplateMailer

	# TODO: hook up to mandrill
	def notification(author)
		mandrill_mail template: '',
		              subject: '',
		              from_name: 'Code School',
		              to: {email: author.email}
	end

end