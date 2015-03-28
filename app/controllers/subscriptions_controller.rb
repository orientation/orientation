class SubscriptionsController < ApplicationController
  def index
    @subscriptions = ArticleSubscription.recent
  end
end
