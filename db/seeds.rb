# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


movie1 = Video.create(title: "The League", description: "Bros", small_cover_url: "Videos/TheLeague_small.jpg" , large_cover_url: "/Videos/TheLeague_large.jpg", category_id: 1)
movie2 = Video.create(title: "Futurama", description: "Cool Story", small_cover_url: "/tmp/futurama.jpg", category_id: 2)
movie2 = Video.create(title: "South Park", description: "Too funny", small_cover_url: "/tmp/south_park.jpg", category_id: 2)



cat1 = Category.create(name: "Comedy")
# cat2 = Category.create(name: "Action")
# cat3 = Category.create(name: "Drama")
# cat4 = Category.create(name: "Sci-Fi")
# cat5 = Category.create(name: "Family")

