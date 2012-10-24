require 'spec_helper'

describe User do
  context ".find_or_create_from_omniauth" do
    before do
      @old_user = { 'provider' => 'google_oauth2', 'uid' => '12345', 'name' => 'peter' }
      @new_user = { 'provider' => 'google_oauth2', 'uid' => '54321', 'name' => 'testuser' }
    end

    let!(:existing_user) { User.create(@old_user)}

    it "finds existing user" do
      User.find_or_create_from_omniauth(@old_user).should eq existing_user
    end

    it "creates user" do
      expect { User.find_or_create_from_omniauth(@new_user) }.to change{ User.count }.from(1).to(2)
    end
  end
end
