

describe User do
  context ".find_or_create_from_omniauth" do
    before do
      @old_user = { 'provider' => 'google_oauth2', 'uid' => '12345', 'info' => { 'name' => 'peter', 'email' => 'peter@codeschool.com' } }.with_indifferent_access
      @new_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'info' => { 'name' => 'testuser', 'email' => 'testuser@codeschool.com' } }.with_indifferent_access
      @unauthorized_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'info' => { 'name' => 'testuser', 'email' => 'evil@example.com' } }.with_indifferent_access
    end

    let!(:existing_user) { User.create(uid: @old_user[:uid], provider: @old_user[:provider], email: @old_user[:info][:email], name: @old_user[:info][:name])}
    let(:old_user) { User.find_or_create_from_omniauth(@old_user) }

    it "finds existing user" do
      expect(old_user).to eq existing_user
    end

    it "creates user" do
      expect { User.find_or_create_from_omniauth(@new_user) }.to change{ User.count }.from(1).to(2)
    end

    it "denies unauthorized user" do
      expect(User.find_or_create_from_omniauth(@unauthorized_user).valid?).to be_falsey
    end
  end

  context "#subscribed_to?(article)" do
    let(:user) { create(:user) }
    let(:article) { create(:article) }
    let!(:article_subscription) { create(:article_subscription, user: user, article: article) }

    subject(:subscribed_to?) { user.subscribed_to?(article) }

    it 'returns the correct value' do
      expect(subscribed_to?).to be_truthy
    end
  end
end
