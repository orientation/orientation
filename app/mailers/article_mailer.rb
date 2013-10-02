# Public: This mailer sends a stale article alert email through
#           Mandrill instead of a normal action mailer email.
#
# article - a stale article (an article that has not been updated for several months)
#
# This email can be tested using the `.test` method:		
#   ArticleMailer.test(:notify_author_of_staleness, email: <author.email>)
#
class ArticleMailer < MandrillMailer::TemplateMailer
	default from: 'orientation@codeschool.com'
	
	def notify_author_of_staleness(article)
		author = article.author
		mandrill_mail template: 'Stale Article Alert',
		              subject: 'Stale Article Alert',
		              from_name: 'Code School Orientation',
		              to: { email: author.email, name: author.name },
		              vars: {
		                'ARTICLE_TITLE' => article.title, 
		                'ARTICLE_URL' => edit_article_url(article)
		              }
	end

	test_setup_for :notify_author_of_staleness do |mailer, options|
	  author = MandrillMailer::Mock.new({
	  	title: 'Test', 
	  	author: MandrillMailer::Mock.new({ 
	  		email: options[:email] 
	  	})
	  })

	  mailer.notify_author_of_staleness(author).deliver
	end


end