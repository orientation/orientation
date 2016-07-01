# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

alvar = User.find_or_initialize_by(name: "Alvar Hanso").tap do |user|
  user.email = "alvar@hanso.dk"
  user.image = ActionController::Base.helpers.asset_path("default_avatar.jpg")
  user.shtick = "I stare at stuff inside buildings"
  user.save
end

tag = Tag.find_or_create_by(name: "video")

Article.find_or_create_by(title: "Welcome to the Island!").tap do |article|
  article.content = "Isn't it nice here?"
  article.author = alvar
  article.tags = [tag]
  article.save
end

["The Hydra", "The Swan", "The Orchid"].each do |station|
  Article.find_or_initialize_by(title: station).tap do |article|
    article.content = <<~MARKDOWN
      This is an example guide. It's just an article with links to other articles!

      - [[Welcome to the Island]]
    MARKDOWN
    article.author = alvar
    article.guide = true
    article.save
  end
end
