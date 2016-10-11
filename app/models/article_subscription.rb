class ArticleSubscription < ApplicationRecord
  include Dateable

  belongs_to :article, counter_cache: :subscriptions_count
  belongs_to :user

  def send_update
    clear_existing_queued_update_jobs if update_queued?
    SendArticleUpdateJob.set(wait: 5.minutes).perform_later(article.id, user.id)
  end

  def update_queued?
    existing_queued_update_jobs.any?
  end

  def existing_queued_update_jobs
    Delayed::Job
      .where(%Q["delayed_jobs"."handler" LIKE '%SendArticleUpdateJob%'])
      .where(%Q["delayed_jobs"."handler" LIKE '%arguments:%#{article_id}%'])
  end

  def clear_existing_queued_update_jobs
    existing_queued_update_jobs.destroy_all
  end
end
