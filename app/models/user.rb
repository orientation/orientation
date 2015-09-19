class User < ActiveRecord::Base
  belongs_to :article
  has_many :articles, foreign_key: "author_id"
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribed_articles, through: :subscriptions, source: :article
  has_many :endorsements, class_name: "ArticleEndorsement"
  has_many :endorsed_articles, through: :endorsements, source: :article
  has_many :edits, class_name: "Article", foreign_key: "editor_id"

  validates :email, presence: true
  validate :whitelisted_email, if: -> { self.class.email_whitelist? }

  def self.author
    joins(:articles).group('users.id').having('count(articles.id) > 0')
  end

  def self.prolific
    joins(articles: :author).
      select('users.*, count(articles.id) as articles_count').
      group('users.id').
      order('articles_count DESC')
  end

  def self.active
    where(active: true)
  end

  def self.find_or_create_from_omniauth(auth)
    find_and_update_from_omniauth(auth) or create_from_omniauth(auth)
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

  def self.find_and_update_from_omniauth(auth)
    find_by(auth.slice("provider","uid")).tap do |user|
      user && user.update_attribute(:image, auth["info"]["image"])
    end
  end

  def self.text_search(query)
    if query.present?
      where("name ILIKE :q OR shtick ILIKE :q", q: "%#{query}%").order('name ASC')
    else
      order(name: :desc)
    end
  end

  def notify_about_stale_articles
    return false unless self.active? # we don't want to send mailers to inactive authors

    articles = self.articles.stale.select(&:ready_to_notify_author_of_staleness?)
    article_ids = articles.map(&:id)
    Delayed::Job.enqueue(StalenessNotificationJob.new(article_ids)) unless article_ids.empty?
  end

  # TODO: improve this query
  def subscribed_to?(article)
    subscriptions.where(article_id: article.id, user_id: self.id).count > 0
  end

  # TODO: improve this query
  def endorsing?(article)
    endorsements.where(article_id: article.id, user_id: self.id).count > 0
  end

  def to_s
    self.name || self.email
  end

  private
  def self.email_whitelist?
    !!ENV['ORIENTATION_EMAIL_WHITELIST']
  end

  def email_whitelist
    ENV["ORIENTATION_EMAIL_WHITELIST"].split(":")
  end

  def whitelisted_email
    if email_whitelist.none? { |email| self.email.include?(email) }
      errors.add(:email, "doesn't match the email domain whitelist: #{email_whitelist}")
    end
  end
end
