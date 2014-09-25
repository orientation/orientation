class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  has_and_belongs_to_many :tags, before_add: :validates_tag
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribers, through: :subscriptions, class_name: "User", source: :user

  attr_reader :tag_tokens

  before_validation :generate_slug
  after_save :update_subscribers
  after_create :increment_tags_counter
  before_destroy :decrement_tags_counter

  validates :slug, uniqueness: true, presence: true

  def self.archived
    where("archived_at IS NOT NULL")
  end
  FRESHNESS_LIMIT = 7.days
  STALENESS_LIMIT = 6.months

  def self.current
    where(archived_at: nil).order("rotted_at DESC")
  end

  def self.fresh
    where("updated_at >= ?", 7.days.ago).where(archived_at: nil).where(rotted_at: nil)
  end

  def self.fresh?(article)
    self.fresh.include?(article)
  end

  def self.ordered_fresh
    fresh.order(updated_at: :desc).limit(20)
  end

  def self.ordered_current
    current.order(updated_at: :desc).limit(20)
  end

  def self.popular
    includes(:subscribers).sort_by{|a| a.subscribers.count }.reverse.take(5)
  end

  def self.rotten
    where("rotted_at IS NOT NULL")
  end

  def self.rotten?(article)
    self.rotten.include?(article)
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

  def author?(user)
    self.author == user
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

  # an article is rotten when it has been manually marked as rotten and
  # the rotted_at timestamp has been set (it defaults to nil)
  def rotten?
    Article.rotten? self
  end

  def refresh!
    update_attribute(:rotted_at, nil)
    touch(:updated_at)
  end

  def rot!
    update_attribute(:rotted_at, Time.now.in_time_zone)
    Delayed::Job.enqueue(SendArticleRottenJob.new(self.id, contributors))
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

  def self.reset_tags_count
    self.all.each do |article|
      tag_count = article.tags.count
      article.update_attribute(:tags_count, tag_count)
    end
  end

  # @user - the user to subscribe to this article
  # Returns the subscription if successfully created
  # Raises otherwise
  def subscribe(user)
    self.subscriptions.find_or_create_by!(user: user)
  end

  # @user - the user to unsubscribed from this article
  # Returns true if the unsubscription was successful
  # Returns false if there was no subscription in the first place
  def unsubscribe(user)
    subscription = self.subscriptions.find_by(user: user)
    return false if subscription.nil?
    return true if subscription.destroy
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

  def contributors
    User.where(id: [self.author_id, self.editor_id]).map do |user|
      { name: user.name, email: user.email }
    end
  end

  def generate_slug
    if self.slug.present? && self.slug == title.parameterize
      self.slug
    else
      self.slug = title.parameterize
    end
  end

  def update_subscribers
    subscriptions.each do |sub|
      sub.send_update_for(self.id)
    end
  end

  def validates_tag(tag)
    self.tags.include?(tag)
  end

  def increment_tags_counter
    self.tags.each do |tag|
      tag.increment!(:articles_count)
    end
  end

  def decrement_tags_counter
    self.tags.each do |tag|
      tag.decrement!(:articles_count)
    end
  end
end
