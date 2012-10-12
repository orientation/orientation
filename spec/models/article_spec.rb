require 'spec_helper'

describe Article do
  it { should belong_to :author }
end
