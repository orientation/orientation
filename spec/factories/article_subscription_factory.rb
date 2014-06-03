# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :article_subscription do
    article 
    user
  end
end
