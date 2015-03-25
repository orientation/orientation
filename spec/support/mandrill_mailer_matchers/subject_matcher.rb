# Public: Matcher for asserting subject
#
#   expected_subject: - Expected subject of email
#
# WelcomeMailer is an instance of MandrillMailler::TemplateMailer
#
# let(:user) { FactoryGirl.create(:user) }
# let(:mailer) { WelcomeMailer.welcome_registered(user) }
# it 'should have the correct data' do
#   mailer.should have_subject('Welcome Subscriber')
# end
#
# Returns true or an error message on failure
#
RSpec::Matchers.define :have_subject do |expected_subject|
  match do |mailer|
    mailer_subject(mailer) == expected_subject
  end

  failure_message do |actual|
    <<-MESSAGE.strip_heredoc
    Expected subject: #{mailer_subject(mailer).inspect} to be: #{expected_subject.inspect}.
  MESSAGE
  end

  failure_message_when_negated do |actual|
    <<-MESSAGE.strip_heredoc
    Expected subject: #{mailer_subject(mailer).inspect} to not be: #{expected_subject.inspect}.
  MESSAGE
  end

  description do
    "be the same subject as #{expected_subject.inspect}"
  end

  def mailer_subject(mailer)
    mailer.data['message']['subject']
  end
end
