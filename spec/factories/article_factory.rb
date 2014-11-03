# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :article do
    author factory: :user
    title { Faker::Lorem.sentence }
    slug { title.parameterize }
    content { Faker::Lorem.paragraphs(1).first }

    trait :fresh do
      created_at 7.months.ago
      updated_at 6.days.ago
    end

    trait :archived do
      archived_at 1.day.ago
    end
  end
end
