# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


[Category, User].each(& :delete_all)
             
User.create!(name:    "Steven Latham",
            email:    "steven@stevenlathamproductions.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Santa Monica, CA",
            bio:      "",
            admin:    true)
             
User.create!(name:    "Tim Lenz",
            email:    "tim@scimantics.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Red Hook, NY",
            bio:      "",
            admin:    true)

["adopt", "volunteer", "donate", "sterilize", "foster", "wildcard"].each do |elem|
  Category.create!(name: elem)
end