class EndorsementsController < ApplicationController
  def index
    @endorsements = ArticleEndorsement.recent
  end
end
