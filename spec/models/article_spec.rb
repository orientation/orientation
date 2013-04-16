require 'spec_helper'

describe Article do
  it { should belong_to :author }
  it { pending "shoulda isn't compatible with Rails 4 HABTM join tables yet."; should have_and_belong_to_many :tags }
end
