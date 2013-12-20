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

  def notify_about_stale_articles
    articles = self.articles.stale.select(&:ready_to_notify_author_of_staleness?)
    article_ids = articles.map(&:id)
    Delayed::Job.enqueue(StalenessNotificationJob.new(article_ids)) unless article_ids.empty?
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
