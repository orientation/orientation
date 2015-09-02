class Team < ActiveRecord::Base
  extend FriendlyId

  has_many :users
  has_many :articles, through: :users, source: :articles
  has_many :subscribed_articles, through: :users, source: :subscribed_articles
  has_many :edits, through: :users, source: :edits

  friendly_id :name, use: [:slugged, :history]
end
