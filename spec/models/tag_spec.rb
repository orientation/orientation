require 'spec_helper'

describe Tag do
  it { pending "shoulda isn't compatible with Rails 4 HABTM join tables yet."; should have_and_belong_to_many :articles }
end
