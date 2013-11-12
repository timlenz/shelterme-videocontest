namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # make_users
    # make_videos
    # make_plays
    make_shares
    # make_votes
  end
end

# def make_users
#   100.times do |n|
#     name = Faker::Name.name
#     email = "example-#{n+1}@testing.org"
#     password  = "password"
#     User.create!(name:     name,
#                  email:    email,
#                  password: password,
#                  password_confirmation: password)
#   end
# end
# 
# def make_videos
#   users = User.all
#   u_count = users.count
#   users.each do |user|
#     Random.rand(1..4).times do
#       title = Faker::Company.catch_phrase
#       category = Random.rand(1..6)
#       panda = "048c982cc6dc20c899bb47934e55b190"
#       user.videos.create!(title: title, category_id: category, panda_video_id: panda)
#     end
#   end
# end

def make_plays
  users = User.all
  videos = Video.all
  u_count = users.count
  v_count = videos.count
  users.each do |user|
    video = Random.rand(1..v_count)
    target = Random.rand(1..1000)
    target.times do
      user.plays.create!(video_id: video)
    end
  end
end

def make_shares
  users = User.all
  videos = Video.all
  u_count = users.count
  v_count = videos.count
  users.each do |user|
    video = Random.rand(1..v_count)
    target = Random.rand(10..1000)
    target.times do
      user.shares.create!(video_id: video)
    end
  end
end

def make_votes
  users = User.all
  videos = Video.all
  u_count = users.count
  v_count = videos.count
  users.each do |user|
    video = Random.rand(1..v_count)
    value = Random.rand(1..5)
    target = Random.rand(10..1000)
    target.times do
      user.votes.create!(video_id: video, value: value)
    end
  end
end