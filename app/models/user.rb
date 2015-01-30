class User < ActiveRecord::Base
  belongs_to :article
  has_many :articles, foreign_key: "author_id"
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribed_articles, through: :subscriptions, source: :article
  has_many :endorsements, class_name: "ArticleEndorsement"
  has_many :endorsed_articles, through: :endorsements, source: :article

  has_many :edits, class_name: "Article", foreign_key: "editor_id"

  domain_regex = /\A([\w\.%\+\-]+)@(codeschool|pluralsight|smarterer)\.com$\z/
  validates :email, presence: true, format: { with: domain_regex }

  mount_uploader :avatar, AvatarUploader

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
    if user = where(auth.slice("provider", "uid")).first
      # Only update the user's image if they don't already have one.
      # This means an OAuth profile image can never override an existing Orientation one.
      update_image(user, auth) if user.image.nil?
      user = destroy_duplicate_user(user)
    else
      # if we can find a user with a matching name, let's avoid creating
      # a duplicate record for that user and instead update the old user
      # record with the new auth info (uid) and email (@codeschool.com)
      if old_user = User.find_by(name: auth["info"]["name"])
        user = update_old_envylabs_user(old_user, auth)
      else
        user = create_from_omniauth(auth)
      end
    end

    return user
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
    subscriptions.where(article_id: article.id).where(user_id: self.id).count > 0
  end

  # TODO: improve this query
  def endorsing?(article)
    endorsements.where(article_id: article.id).where(user_id: self.id).count > 0
  end

  def to_s
    self.name || self.email
  end

  private

  def self.update_image(user, auth)
    user.image = auth["info"]["image"]
    user.save
  end

  def self.update_old_envylabs_user(old_user, auth)
    old_user.email = auth["info"]["email"]
    old_user.uid = auth["uid"]

    old_user.save!

    old_user
  end

  def self.destroy_duplicate_user(new_user)
    if User.where(name: new_user.name).length <= 1
      return new_user
    else
      old_user = User.where(name: new_user.name).where("email ILIKE ?", "%envylabs.com").first

      if old_user
        old_user.email = new_user.email
        old_user.uid = new_user.uid
        old_user.save!

        new_user.destroy

        old_user
      else
        return new_user
      end
    end
  end
end
