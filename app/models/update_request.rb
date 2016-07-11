class UpdateRequest < ActiveRecord::Base
  belongs_to :article
  belongs_to :reporter, class_name: "User"

  after_create :rot_article

  private

  def rot_article
    article.rot!(reporter_id, description)
  end
end
