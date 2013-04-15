require 'spec_helper'

describe Article do
  it { should belong_to :author }
  it { should have_and_belong_to_many :tags }
end
