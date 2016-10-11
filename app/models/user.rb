class User < ApplicationRecord
  belongs_to :article
  has_many :articles, foreign_key: "author_id", dependent: :restrict_with_exception
  has_many :subscriptions, class_name: "ArticleSubscription", dependent: :destroy
  has_many :subscribed_articles, through: :subscriptions, source: :article
  has_many :endorsements, class_name: "ArticleEndorsement", dependent: :destroy
  has_many :endorsed_articles, through: :endorsements, source: :article
  has_many :edits, class_name: "Article", foreign_key: "editor_id", dependent: :restrict_with_exception
  has_many :rot_reports, class_name: "Article", foreign_key: "rot_reporter_id", dependent: :restrict_with_exception

  store_accessor :preferences,
    :private_email

  validates :email, presence: true
  validate :whitelisted_email, if: -> { self.class.email_whitelist_enabled? }

  def self.author
    joins(:articles).group('users.id').having('count(articles.id) > 0')
  end

  def self.prolific
    joins(articles: :author).
      select('users.*, count(articles.id) as articles_count').
      group(:id).
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

  def administrator?
    ENV['ADMINISTRATORS'].split(':').include? id.to_s
  end

  def notify_about_stale_articles
    return false unless self.active? # we don't want to send mailers to inactive authors

    articles = self.articles.stale.select(&:ready_to_notify_author_of_staleness?)
    article_ids = articles.map(&:id)
    StalenessNotificationJob.perform_later(article_ids) unless article_ids.empty?
  end

  def notify_about_rotten_articles
    return false unless self.active? # we don't want to send mailers to inactive authors

    articles = self.articles.rotten
    article_ids = articles.map(&:id)
    RottenNotificationJob.perform_later(article_ids) unless article_ids.empty?
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

  def replace_and_destroy!(other_user)
    replace_with_user!(other_user) && destroy!
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

  def replace_with_user!(replacement)
    articles.each { |article| article.update! author: replacement }
    articles.reload

    edits.each { |edit| edit.update! editor: replacement }
    edits.reload

    rot_reports.each { |rot_report| rot_report.update! rot_reporter: replacement }
    rot_reports.reload

    self
  end
end
