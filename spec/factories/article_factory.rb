FactoryBot.define do
  factory :article do
    author factory: :user
    title { Faker::Book.title }
    slug { title.parameterize }
    content { Faker::Markdown.sandwich }

    trait :stale do
      created_at { 7.months.ago }
      updated_at { 7.months.ago }
    end

    trait :fresh do
      created_at { 7.months.ago }
      updated_at { 6.days.ago }
    end

    trait :archived do
      archived_at { 1.day.ago }
    end

    trait :outdated do
      outdated_at { Time.now }
      outdatedness_reporter { create(:user) }
    end

    trait :guide do
      guide { true }
    end

    trait :popular do
      after(:create) do |article|
        article.count_visit
      end
    end

    trait :with_tag do
      after(:create) { |a| create(:articles_tag, article: a) }
    end

    trait :with_endorsement do
      after(:create) { |a| create(:article_endorsement, article: a) }
    end

    trait :with_subscription do
      after(:create) { |a| create(:article_subscription, article: a) }
    end

    trait :with_view do
      after(:create) { |a| create(:article_view, article: a) }
    end
  end
end
