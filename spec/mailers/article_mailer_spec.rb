require 'spec_helper'
 
describe ArticleMailer do
  context "notify_author_of_staleness" do
    let(:user) { FactoryGirl.create(:user, email: 'aimee@envylabs.com') }
    let(:article) { FactoryGirl.create(:article, :stale, author: user)}
    let(:mailer) { described_class.notify_author_of_staleness(article).deliver }

    it 'has the correct subject' do
      mailer['subject'].value.should == 'Stale Article Alert'
    end

    it 'gets sent to the right person' do
      mailer['to'].value.should == user.email
    end

    it 'sets the correct "from" value' do
      mailer['from'].value.should == 'orientation@codeschool.com'
    end 

    it 'passes the correct variables into the message' do
      mailer.body.encoded.include?(user.name).should == true
      mailer.body.encoded.include?(article.title).should == true
    end
  end
end