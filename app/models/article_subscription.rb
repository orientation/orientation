class ArticleSubscription < ActiveRecord::Base
  include Dateable

  belongs_to :article, counter_cache: :subscriptions_count
  belongs_to :user

  def send_update
    clear_existing_queued_update_jobs if update_queued?
    Delayed::Job.enqueue(SendArticleUpdateJob.new(self.article_id, user.id), run_at: 5.minutes.from_now)
  end

  def update_queued?
    existing_queued_update_jobs.size.nonzero? ? true : false
  end

  def existing_queued_update_jobs
    matching_jobs = Delayed::Job.select do |job|
      job.handler =~ /SendArticleUpdateJob/ && job.handler =~ /article_id: #{self.article_id}/
    end
  end

  def clear_existing_queued_update_jobs
    existing_queued_update_jobs.each(&:destroy)
  end
end
