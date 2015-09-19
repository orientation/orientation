FactoryGirl.define do
  factory :user, class: User do
    provider "Faker::Lorem.sentence"
    uid { "#{Faker::Number.digit}" }
    name { Faker::Name.name }
    sequence(:email) { |n| "email#{n}@hanso.dk" }
  end
end
