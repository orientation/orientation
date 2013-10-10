class User < ActiveRecord::Base
  has_many :articles, foreign_key: "author_id"

  domain_regex = /\A([\w\.%\+\-]+)@(envylabs|codeschool)\.com$\z/
  validates :email, presence: true, format: { with: domain_regex }


  def self.author
    joins(:articles).group('users.id').having('count(articles.id) > 0')
  end

  def self.prolific
    joins(articles: :author).
      select('users.*, count(articles.id) as articles_count').
      group('users.id').
      order('articles_count DESC')
  end

  def self.find_or_create_from_omniauth(auth)
    if user = where(auth.slice("provider", "uid")).first
      # TODO: remove when all existing users have an image
      update_image(user, auth)
    else
      user = create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth(auth)
    create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.image = auth["info"]["image"]
    end
  end

  def notify_if_article_staleness
    # rake notify_author_if_article_staleness will run daily and call this method

    # if a notification for this user's articles hasn't been queued this week, add a notification to the queue
    # e.g. don't queue a notification for a user more than once per week

    # The job queue will be worked off daily.
    # The article's last_notified_author_at value will be set to the date that the job is run.

    articles = self.articles.stale
    articles = articles.select{|article| article if (article.last_notified_author_at.nil? || article.last_notified_author_at < 1.week.ago)}
    Delayed::Job.enqueue(NotifyAuthorOfStalenessJob.new(articles)) unless articles.empty?
  end

  def to_s
    self.name || self.email
  end

  private

  def self.update_image(user, auth)
    user.image = auth["info"]["image"]
    user.save

    user
  end
end
