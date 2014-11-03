class Article < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  has_and_belongs_to_many :tags
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribers, through: :subscriptions, class_name: "User", source: :user

  attr_reader :tag_tokens

  before_validation :generate_slug
  after_save :update_subscribers

  validates :slug, uniqueness: true, presence: true

  # @returns [Hash] a hash of categories, and all current articles within each
  def self.by_topic
    {}.tap do |grouped|
      select("distinct topic").map(&:topic).sort.each do |c|
        grouped[c] = current.where(topic: c).order(:title)
      end
    end
  end

  def self.archived
    where("archived_at IS NOT NULL")
  end

  def self.current
    where(archived_at: nil).order("created_at ASC")
  end

  def self.fresh
    where("updated_at >= ?", 7.days.ago).where(archived_at: nil)
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

  def refresh!
    touch(:updated_at)
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
end
