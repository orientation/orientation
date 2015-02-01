class SendArticleEndorsementJob < Struct.new(:endorsement_id)
  def perform
    endorsement = ArticleEndorsement.find(endorsement_id)
    contributors = endorsement.article.contributors
    article = endorsement.article
    endorser = endorsement.user

    ArticleMailer.send_endorsement_notification_for(article, contributors, endorser).deliver
  end
end
