# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

orientation = User.find_or_initialize_by(name: "Orientation").tap do |user|
  user.email = "about@orientation.io"
  user.image = ActionController::Base.helpers.asset_path("default_avatar.jpg")
  user.shtick = "I can orient you in Orientation"
  user.save
end

tag = Tag.find_or_create_by(name: "meta")

Article.find_or_create_by(title: "About").tap do |article|
  article.content = <<~MARKDOWN
    # What is Orientation?

    It's a place to share knowledge you depend on and help people who rely on it 
    the most stay connected with it.

    # How does it work? 
      
    You write articles inside Orientation. You keep those article short and 
    focus on a single topic. Once you're done, you can share an article with 
    anyone and they can subscribe to it. Whenever it changes, they'll know 
    about it. 

    # How is it better?

    First, simplicity. 

    You can create an article in plain text. If you want to add markup like 
    emphasis, links, and images, you can use Markdown and we'll help you if 
    you're not familiar with it.

    Second, freshness. 

    There are many ways to write documentation. The tricky part comes later:
    when you need to find the documentation and keep it up-to-date. Orientation
    automatically decays articles that have not been updated for a while. They
    first become stale, which notifies their authors and editors so they can
    know to update them. Then they eventually become outdated, signaling that
    their information is likely inaccurate and needs updating. At any time, 
    an Orientation reader can mark an article as outdated, speeding up this 
    process.

    Third, connectedness.

    When you need to look up documentation for something it's often because you
    either can't remember it or aren't familiar with the domain. This means you
    will not just depend on the information once, but regularly. Most
    documentation systems are somehow based on the assumption that information
    doesn't evolve. By subscribing to an article in Orientation, you will be
    notified when anyone updates it. You're connected to knowledge you depend
    on.

  MARKDOWN
  article.author = orientation
  article.tags = [tag]
  article.guide = true
  article.save
end

5.times { FactoryGirl.create(:article, :fresh) }
5.times { FactoryGirl.create(:article, :stale) }
5.times { FactoryGirl.create(:article, :outdated) }
5.times { FactoryGirl.create(:article, :archived) }
