# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cristian = User.create(username: "Cristian", email: "cristianrennella@gmail.com", password: "password")
david = User.create(username: "David", email: "davidrennella@gmail.com", password: "password")
joaquin = User.create(username: "Joaquin", email: "joaco@gmail.com", password: "password")

Category.create(name: "Action")
Category.create(name: "Romantic")

futurama = Video.create(title: "Futurama", description: "some description...", small_cover_url: "futurama.jpg", large_cover_url: "futurama.jpg", category_id: 1)
family = Video.create(title: "Family Guy", description: "some description...", small_cover_url: "family_guy.jpg", large_cover_url: "family_guy.jpg", category_id: 1)
south = Video.create(title: "South Park", description: "some description...", small_cover_url: "south_park.jpg", large_cover_url: "south_park.jpg", category_id: 2)
Video.create(title: "Futurama", description: "some description...", small_cover_url: "futurama.jpg", large_cover_url: "futurama.jpg", category_id: 1)
Video.create(title: "Family Guy", description: "some description...", small_cover_url: "family_guy.jpg", large_cover_url: "family_guy.jpg", category_id: 1)
Video.create(title: "South Park", description: "some description...", small_cover_url: "south_park.jpg", large_cover_url: "south_park.jpg", category_id: 2)
Video.create(title: "Futurama", description: "some description...", small_cover_url: "futurama.jpg", large_cover_url: "futurama.jpg", category_id: 1)
Video.create(title: "Family Guy", description: "some description...", small_cover_url: "family_guy.jpg", large_cover_url: "family_guy.jpg", category_id: 1)
Video.create(title: "South Park", description: "some description...", small_cover_url: "south_park.jpg", large_cover_url: "south_park.jpg", category_id: 2)
Video.create(title: "Family Guy", description: "some description...", small_cover_url: "family_guy.jpg", large_cover_url: "family_guy.jpg", category_id: 1)

Review.create(description: "some description...", rating: 4, user: cristian, video: futurama, created_at: 1.day.ago)
Review.create(description: "another description...", rating: 3, user: cristian, video: family, created_at: 2.day.ago)
Review.create(description: "bla bla bla", rating: 5, user: cristian, video: south, created_at: 3.day.ago)
Review.create(description: "some description...", rating: 2, user: david, video: futurama, created_at: 4.day.ago)
Review.create(description: "hi hi hi...", rating: 5, user: david, video: futurama, created_at: 5.day.ago)

# Followship.create(user_id: 2, follower_id: 1)
# Followship.create(user_id: 3, follower_id: 2)