FactoryGirl.define do
  factory :article do
    author factory: :user
    title { Faker::Lorem.sentence }
    slug { title.parameterize }
    content { Faker::Hacker.say_something_smart }

    trait :stale do
      created_at 7.months.ago
      updated_at 7.months.ago
    end

    trait :fresh do
      created_at 7.months.ago
      updated_at 6.days.ago
    end

    trait :archived do
      archived_at 1.day.ago
    end

    trait :rotten do
      rotted_at Time.now
    end

    trait :guide do
      guide true
    end

    trait :popular do
      after(:create) do |article|
        article.count_visit
      end
    end
  end
end
