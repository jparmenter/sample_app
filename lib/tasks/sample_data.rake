namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    make_replys
    make_message
  end
end

def make_users
  admin = User.create!(username: "example",
                       name: "Example User",
                       email: "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name = Faker::Name.name
    username = "example-#{n+1}"
    email = "#{username}@railstutorial.org"
    password = "password"
    User.create(username: username,
                name: name,
                email: email,
                password: password,
                password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_replys
  users = User.all[5..15]
  user = users.first
  users.each do |reply_user|
    content = Faker::Lorem.sentence(5)
    reply_user.microposts.create!(content: "@#{user.username} #{content}")
  end
end

def make_message
  users = User.all[6..16]
  user = User.first
  20.times do
    content = Faker::Lorem.sentence(15)
    users.each do |sender_user|
      sender_user.messages.create!(content: content, receiver_id: user.id)
      user.messages.create!(content: content, receiver_id: sender_user.id)
    end
  end
end
