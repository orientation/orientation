class SendArticleEndorsementJob < Struct.new(:endorsement_id, :user_id)
  def perform
    endorsement = ArticleEndorsement.find(endorsement_id)
    author = endorsement.article.author
    article = endorsement.article
    endorser = endorsement.user

    ArticleMailer.send_endorsement_for(article, author, endorser).deliver
  end
end
