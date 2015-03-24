# Public: Matcher for asserting to email
#
# expected_to - The Hash options used to designate to whom the email is sent, options are optional (default: {}):
#             :name - Name of reciever
#             :email - email of reciever
#
# WelcomeMailer is an instance of MandrillMailler::TemplateMailer
#
# let(:user) { FactoryGirl.create(:user) }
# let(:mailer) { WelcomeMailer.welcome_registered(user) }
# it 'should have the correct data' do
#   mailer.should send_email_to(email: user.email, name: 'Code School Customer')
# end
#
# it 'should have the correct to name' do
#   mailer.should send_email_to(name: 'Code School Customer')
# end
#
# it 'should have the correct email' do
#   mailer.should send_email_to(email: user.email')
# end
#
# Returns true or an error message on failure
#
RSpec::Matchers.define :send_email_to do |expected_to|
  match do |mailer|
    to_arr = mailer_to_data(mailer)
    opts_found = false
    expected_to.each_pair do |key, value|
      opts_found = to_arr.any? do |to_opt|
        to_opt.symbolize_keys!
        bool_arr = [
          (to_opt[:email] == value if key.to_sym == :email),
          (to_opt[:name] == value if key.to_sym == :name)
        ]
        !bool_arr.compact.any? {|i| i == false}
      end
      break unless opts_found
    end
    opts_found
  end

  failure_message do |actual|
    <<-MESSAGE.strip_heredoc
    Expected to variables: #{mailer_to_data(mailer).inspect} to include data: #{expected_to.inspect} but it does not.
  MESSAGE
  end

  failure_message_when_negated do |actual|
    <<-MESSAGE.strip_heredoc
    Expected to variables: #{mailer_to_data(mailer).inspect} to not include data: #{expected_to.inspect} but it does.
  MESSAGE
  end

  description do
    "be the same to data as #{expected_to.inspect}"
  end

  def mailer_to_data(mailer)
    # {email: 'user@email.com', name: 'larry'}
    mailer.data['message']['to']
  end
end
