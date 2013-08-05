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
            street:   "3401 Stewart Ave",
            city:     "Los Angeles",
            state:    "CA",
            zipcode:  "90066",
            bio:      "",
            date_of_birth: "1969-02-08 08:00:00",
            phone:    "310-729-0528"
            admin:    true)
             
User.create!(name:    "Tim Lenz",
            email:    "tim@scimantics.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            street:   "27 Lavender Ridge Rd",
            city:     "Red Hook",
            state:    "NY",
            zipcode:  "12571",
            bio:      "",
            date_of_birth: "1969-09-15 07:00:00",
            phone:    "646-535-9639"
            admin:    true)

["adopt", "volunteer", "donate", "sterilize", "foster", "wildcard"].each do |elem|
  Category.create!(name: elem)
end