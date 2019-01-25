FactoryBot.define do
  factory :article do
    author factory: :user
    title { Faker::Book.title }
    slug { title.parameterize }
    content { Faker::Markdown.sandwich }

    transient do
      count 0
    end

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
      after(:create) do |article, evaluator|
        if evaluator.count.present?
          create_list(:articles_tag, evaluator.count, article: article)
        else
          create(:articles_tag, article: article)
        end
      end
    end

    trait :with_endorsement do
      after(:create) do |article, evaluator|
        if evaluator.count.present?
          create_list(:article_endorsement, evaluator.count, article: article)
        else
          create(:article_endorsement, article: article)
        end
      end
    end

    trait :with_subscription do
      after(:create) do |article, evaluator|
        if evaluator.count.present?
          create_list(:article_subscription, evaluator.count, article: article)
        else
          create(:article_subscription, article: article)
        end
      end
    end

    trait :with_view do
      after(:create) do |article, evaluator|
        if evaluator.count.present?
          create_list(:article_view, evaluator.count, article: article)
        else
          create(:article_view, article: article)
        end
      end
    end
  end
end
