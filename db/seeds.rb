# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
  name: "Alvar Hanso",
  email: "alvar@hanso.dk",
  image: ActionController::Base.helpers.asset_path("default_avatar.jpg"),
  shtick: "I stare at stuff inside buildings"
)

tag = Tag.create(name: "video")

Article.create(
  title: "Welcome to the Island!",
  content: "Isn't it nice here?",
  author: User.first,
  tags: [tag]
)

["The Hydra", "The Swan", "The Orchid"].each do |station|
  Article.create(
    title: station,
    content: "This is an example guide. It's just an article with links to other articles!\n\n- [Welcome](/articles/welcome-to-the-island)",
    author: User.first,
    guide: true
  )
end
