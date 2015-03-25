# Public: Matcher for asserting template
#
#   template_name: - name of template in mandrill the mailer sends to
#
# WelcomeMailer is an instance of MandrillMailler::TemplateMailer
#
# let(:user) { FactoryGirl.create(:user) }
# let(:mailer) { WelcomeMailer.welcome_registered(user) }
# it 'should have the correct data' do
#   mailer.should use_template('Welcome Subscriber')
# end
#
# Returns true or an error message on failure
#
RSpec::Matchers.define :use_template do |expected_template|
  match do |mailer|
    mailer_template(mailer) == expected_template
  end

  failure_message do |actual|
    <<-MESSAGE.strip_heredoc
    Expected template: #{mailer_template(mailer).inspect} to be: #{expected_template.inspect}.
  MESSAGE
  end

  failure_message_when_negated do |actual|
    <<-MESSAGE.strip_heredoc
    Expected template: #{mailer_template(mailer).inspect} to not be: #{expected_template.inspect}.
  MESSAGE
  end

  description do
    "be the same template as #{expected_template.inspect}"
  end

  def mailer_template(mailer)
    mailer.data['template_name']
  end
end
