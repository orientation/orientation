FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.unique.words(1).first }
  end
end
