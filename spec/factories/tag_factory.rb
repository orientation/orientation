FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.words(1).first }
  end
end
