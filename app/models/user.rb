class User < ActiveRecord::Base
  belongs_to :article
  has_many :articles, foreign_key: "author_id"
  has_many :subscriptions, class_name: "ArticleSubscription"
  has_many :subscribed_articles, :through => :subscriptions, source: :articles

  has_many :edits, class_name: "Article", foreign_key: "editor_id"

  domain_regex = /\A([\w\.%\+\-]+)@(codeschool)\.com$\z/
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
    else
      user = create_from_omniauth(auth)
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

  # TODO: improve this query
  def subscribed_to?(article)
    subscriptions.where(article_id: article.id).where(user_id: self.id).count > 0
  end

  def to_s
    self.name || self.email
  end

  private

  def self.update_image(user, auth)
    user.image = auth["info"]["image"]
    user.save
  end
end
