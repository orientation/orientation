class User < ApplicationRecord
  has_many :articles, foreign_key: "author_id"
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribed_articles, through: :subscriptions, source: :article
  has_many :endorsements, class_name: "ArticleEndorsement"
  has_many :endorsed_articles, through: :endorsements, source: :article
  has_many :edits, class_name: "Article", foreign_key: "editor_id"
  has_many :views, class_name: "Article::View"

  store_accessor :preferences,
    :private_email

  validates :email, presence: true
  validate :whitelisted_email, if: -> { self.class.email_whitelist_enabled? }

  scope :active, -> { where(active: true) }
  scope :author, lambda {
    joins(:articles).group('users.id').having('count(articles.id) > 0')
  }

  scope :prolific, lambda {
    joins(articles: :author).
      select('users.*, count(articles.id) as articles_count').
      group(:id).
      order('articles_count DESC')
  }

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

  def all_contributions_count
    article_count + edit_count
  end

  def notify_about_stale_articles
    return false if inactive?

    stale_articles_ids = articles.stale.
      select(&:ready_to_send_staleness_notification_for?).map(&:id)

    if stale_articles_ids.any?
      ArticleStaleWorker.perform_async(stale_articles_ids)
    end
  end

  def inactive?
    !active?
  end

  def subscribed_to?(article)
    subscriptions.where(article_id: article.id, user_id: id).any?
  end

  def endorsing?(article)
    endorsements.where(article_id: article.id, user_id: id).any?
  end

  def email_status
    private_email ? "Public" : "Private"
  end

  def to_s
    self.name || self.email
  end

  private
  def self.email_whitelist_enabled?
    !!ENV['ORIENTATION_EMAIL_WHITELIST']
  end

  def email_whitelist
    ENV["ORIENTATION_EMAIL_WHITELIST"].split(":")
  end

  def whitelisted_email
    if email_whitelist.none? { |rule| email.include?(rule) }
      errors.add(:email, "doesn't match the email domain whitelist: #{email_whitelist}")
    end
  end
end
