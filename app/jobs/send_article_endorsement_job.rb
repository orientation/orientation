class SendArticleEndorsementJob < ApplicationJob
  queue_as :default

  def perform(endorsement_id)
    endorsement  = ArticleEndorsement.find(endorsement_id)
    article      = endorsement.article
    endorser     = endorsement.user
    contributors = article.contributors

    ArticleMailer.send_endorsement_notification_for(article, contributors, endorser).deliver
  end
end
