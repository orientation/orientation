require "ostruct"

class Article < ActiveRecord::Base
  include Dateable
  extend ActionView::Helpers::DateHelper
  extend FriendlyId

  friendly_id :title, use: [:slugged, :history]

  def should_generate_new_friendly_id?
    !has_friendly_id_slug? or title_changed?
  end

  def has_friendly_id_slug?
    slugs.where(slug: friendly_id).exists?
  end

  belongs_to :author, class_name: "User"
  belongs_to :editor, class_name: "User"
  has_many :articles_tags, dependent: :destroy
  has_many :tags, through: :articles_tags, counter_cache: :tags_count
  has_many :subscriptions, class_name: "ArticleSubscription", counter_cache: true, dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: "User", source: :user
  has_many :endorsements, class_name: "ArticleEndorsement", counter_cache: true, dependent: :destroy
  has_many :endorsers, through: :endorsements, class_name: "User", source: :user

  attr_reader :tag_tokens

  validates :title, presence: true

  after_save :update_subscribers
  after_save :notify_slack
  after_destroy :notify_slack

  FRESHNESS_LIMIT = 7.days
  STALENESS_LIMIT = 6.months

  FRESHNESS = "Created within the last #{distance_of_time_in_words(FRESHNESS_LIMIT)}."
  STALENESS = "Updated over #{distance_of_time_in_words(STALENESS_LIMIT)} ago."
  ROTTENNESS = "Deemed in need of an update."
  POPULARITY = "Endorsed, subscribed, & visited."
  ARCHIVAL = "Outdated & ignored in searches."

  scope :archived, -> { where.not(archived_at: nil) }
  scope :current, -> { where(archived_at: nil).order(rotted_at: :desc).order(updated_at: :desc).order(created_at: :desc) }
  scope :fresh, -> do
    where("updated_at >= ?", FRESHNESS_LIMIT.ago).
      where(archived_at: nil).
      where(rotted_at: nil)
  end
  scope :guide, -> { where(guide: true) }
  scope :popular, -> { order("endorsements_count DESC, subscriptions_count DESC, visits DESC") }
  scope :rotten, -> { where("rotted_at IS NOT NULL") }
  scope :stale, -> do
    where("updated_at < ?", STALENESS_LIMIT.ago)
  end

  def self.count_visit(article_instance)
    self.increment_counter(:visits, article_instance.id)
  end

  def count_visit
    self.class.count_visit(self)
  end

  def self.searchable_language
    'english'
  end

  def self.text_search(query, scope = nil)
    scope ||= current

    if query.present?
      scope.fuzzy_search({ title: query, content: query }, false)
    else
      scope
    end
  end

  def author?(user)
    self.author == user
  end

  def archive!
    update_attribute(:archived_at, Time.now.in_time_zone)
  end

  def archived?
    archived_at.present?
  end

  def different_editor?
    author != editor
  end

  def edited?
    self.editor.present?
  end

  def fresh?
    !archived? && !rotten? && updated_at >= FRESHNESS_LIMIT.ago
  end

  def stale?
    updated_at < STALENESS_LIMIT.ago
  end

  def rotten?
    rotted_at.present?
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
    self.last_notified_author_at > 1.week.ago.beginning_of_day
  end

  def ready_to_notify_author_of_staleness?
    self.never_notified_author? or !self.recently_notified_author?
  end

  def self.reset_tags_count
    pluck(:id).each do |article_id|
      reset_counters(article_id, :tags)
    end
  end

  def contributors
    User.where(id: [self.author_id, self.editor_id]).uniq.map do |user|
      { name: user.name, email: user.email }
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

  # @user - the user to have endorse this article
  # Returns the endorsement if successfully created
  # Raises otherwise
  def endorse_by(user)
    self.endorsements.find_or_create_by!(user: user)
  end

  # @user - the user to have unendorse this article
  # Returns true if the unendorsement was successful
  # Returns false if there was no endorsement in the first place
  def unendorse_by(user)
    endorsement = self.endorsements.find_by(user: user)
    return false if endorsement.nil?
    return true if endorsement.destroy
  end

  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def to_s
    title
  end

  def to_speakerphone
    OpenStruct.new(author: author.name, title: title, slug: slug)
  end

  def to_param
    slug
  end

  def unarchive!
    update_attribute(:archived_at, nil)
  end

  private

  def update_subscribers
    subscriptions.each do |subscription|
      subscription.send_update
    end
  end

  def notify_slack
    Speakerphone.new(self, state).shout
  end

  def created?
    created_at == updated_at
  end

  def state
    if created?
      :created
    elsif destroyed?
      :destroyed
    else
      :updated
    end
  end
end
