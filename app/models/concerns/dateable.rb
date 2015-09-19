module Dateable
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { order(updated_at: :desc) }
  end
end
