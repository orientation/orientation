require 'spec_helper'

describe Author do
  it { should have_many :articles }
end
