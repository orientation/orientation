FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.unique.words(number: 1).first }
  end
end
