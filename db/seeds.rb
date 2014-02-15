# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([{ name: "Alvar Hanso", email: "alvar@codeschool.com"}])
Tag.create([{ name: "video" }])
Article.create([{ title: "Welcome to the Island!", content: "Isn't it nice here?", author: User.first}])
