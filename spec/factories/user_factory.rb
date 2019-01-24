FactoryBot.define do
  factory :user, class: User do
    provider { Faker::Company.name.parameterize.underscore }
    uid { "#{Faker::Number.digit}" }
    name { Faker::Name.name }
    sequence(:email) { |n| "example-email#{n}@orientation.io" }
    avatar { "http://i.pravatar.cc/160?u=#{email}" }
  end
end
