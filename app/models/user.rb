class User < ActiveRecord::Base
  has_many :articles, foreign_key: "author_id"
  
  domain_regex = /\A([\w\.%\+\-]+)@(envylabs|codeschool)\.com$\z/
  validates :email, presence: true, format: { with: domain_regex }


  def self.author
    self.select("users.*").joins(:articles).group('users.id').having('count(articles.id) > 0')
  end

  def self.find_or_create_from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    # TODO: remove when all existing users have an image
    user.image = auth["info"]["image"] unless user.image.present?
    user
  end

  def self.create_from_omniauth(auth)
    create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.image = auth["info"]["image"]

      return false unless user.valid?
    end
  end

  def to_s
    self.name || self.email
  end
end
