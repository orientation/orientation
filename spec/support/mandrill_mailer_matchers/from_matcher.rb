# Public: Matcher for asserting from email
#
# expected_options - The Hash options used to refine the selection (default: {}):
#             :email - expected from email
#             :name - expected from name
#
# WelcomeMailer is an instance of MandrillMailler::TemplateMailer
#
# let(:user) { FactoryGirl.create(:user) }
# let(:mailer) { WelcomeMailer.welcome_registered(user) }
# it 'should have the correct data' do
#   mailer.should be_from('support@codeschool.com')
# end
#
# Returns true or an error message on failure
#
RSpec::Matchers.define :be_from do |expected_options|
  match do |mailer|
    bool_arr = [(mailer_from_email(mailer) == expected_options[:email] if expected_options[:email]),
    (mailer_from_name(mailer) == expected_options[:name] if expected_options[:name])]
    !bool_arr.compact.any? {|i| i == false}
  end

  failure_message do |actual|
    <<-MESSAGE.strip_heredoc
    Expected from vars: #{mailer_from_email(mailer).inspect} to be: #{expected_options.inspect}.
  MESSAGE
  end

  failure_message_when_negated do |actual|
    <<-MESSAGE.strip_heredoc
    Expected from vars: #{mailer_from_email(mailer).inspect} to not be: #{expected_options.inspect}.
  MESSAGE
  end

  description do
    "be the same from vars as #{expected_options.inspect}"
  end

  def mailer_from_email(mailer)
    mailer.data['message']['from_email']
  end

  def mailer_from_name(mailer)
    mailer.data['message']['from_name']
  end
end
