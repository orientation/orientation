# Public: Matcher for asserting merge vars have certain data.
#
# expected_data - Data to compare to the merge vars
#
# WelcomeMailer is an instance of MandrillMailler::TemplateMailer
#
# let(:user) { FactoryGirl.create(:user) }
# let(:mailer) { WelcomeMailer.welcome_registered(user) }
# it 'should have the correct data' do
#   mailer.should have_merge_data('USER_EMAIL' => user.email)
# end
#
# Returns true or an error message on failure
#
RSpec::Matchers.define :have_merge_data do |expected_data|
  match do |actual|
    has_match = false
    expected_data.each_pair do |key, value|
      has_match = merge_vars_from(actual).any? do |obj|
        obj['name'] == key && obj['content'] == value
      end
      break unless has_match
    end
    has_match
  end

  failure_message do |actual|
    <<-MESSAGE.strip_heredoc
    Expected merge variables: #{merge_vars_from(actual).inspect} to include data: #{expected_data.inspect} but it does not.
  MESSAGE
  end

  failure_message_when_negated do |actual|
    <<-MESSAGE.strip_heredoc
    Expected merge variables: #{merge_vars_from(actual).inspect} to not include data: #{expected_data.inspect} but it does.
  MESSAGE
  end

  description do
    "be the same data as #{expected_data.inspect}"
  end

  def merge_vars_from(mailer)
    # Merge vars are in format:
    # [{"name"=>"USER_EMAIL", "content"=>"zoila@homenick.name"},{"name"=>"USER_NAME", "content"=>"Bob"}]
    mailer.data['message']['global_merge_vars']
  end
end
