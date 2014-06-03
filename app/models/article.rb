class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  has_and_belongs_to_many :tags
  has_many :subscribed_users, class_name: "User", foreign_key: "article_subscription_id"
  has_many :users, :through => :article_subscriptions

  attr_reader :tag_tokens

  before_validation :generate_slug

  validates :slug, uniqueness: true, presence: true

  def self.archived
    where("archived_at IS NOT NULL")
  end

  def self.current
    where(archived_at: nil)
  end

  def self.fresh
    where("updated_at >= ?", 7.days.ago)
  end

  def self.fresh?(article)
    self.fresh.include?(article)
  end

  def self.stale
    where("updated_at < ?", 6.months.ago)
  end

  def self.stale?(article)
    self.stale.include?(article)
  end

  def self.text_search(query)
    if query.present?
      where("title ILIKE :q OR content ILIKE :q", q: "%#{query}%").order('title ASC')
    else
      order(updated_at: :desc)
    end
  end

  def self.ordered_fresh
    current.order(updated_at: :desc).limit(20)
  end

  def archive!
    update_attribute(:archived_at, Time.now.in_time_zone)
  end

  def archived?
    !self.archived_at.nil?
  end

  def different_editor?
    author != editor
  end

  def edited?
    self.editor.present?
  end

  # an article is fresh when it has been created or updated 7 days ago
  # or more recently
  def fresh?
    Article.fresh? self
  end

  # an article is stale when it has been created over 4 months ago
  # and has never been updated since
  def stale?
    Article.stale? self
  end

  def never_notified_author?
    self.last_notified_author_at.nil?
  end

  def recently_notified_author?
    return false if never_notified_author?
    self.last_notified_author_at > 1.week.ago
  end

  def ready_to_notify_author_of_staleness?
    self.never_notified_author? or !self.recently_notified_author?
  end

  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def to_s
    title
  end

  def to_param
    slug
  end

  def unarchive!
    update_attribute(:archived_at, nil)
  end

  private

  def generate_slug
    if self.slug.present? && self.slug == title.parameterize
      self.slug
    else
      self.slug = title.parameterize
    end
  end
end
