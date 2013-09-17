# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :user, class: User do
    provider "Faker::Lorem.sentence"
    uid { "#{Faker::Number.digit}" }
    name "Faker::Lorem.sentence"
    sequence(:email) { |n| "email#{n}@envylabs.com" }
  end
end