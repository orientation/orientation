class ArticleEndorsementWorker
  include Sidekiq::Worker

  def perform(endorsement_id)
    endorsement  = ArticleEndorsement.includes(
      :user, article: [:author, :editor]
    ).find(endorsement_id)
    article      = endorsement.article
    endorser     = endorsement.user
    contributors = article.contributors(excluding: endorser)

    ArticleMailer.send_endorsement_notification_for(
      article, contributors, endorser
    ).deliver
  end
end
