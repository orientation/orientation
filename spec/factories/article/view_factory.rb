FactoryBot.define do
  factory :article_view, class: Article::View do
    article
    user
  end
end
