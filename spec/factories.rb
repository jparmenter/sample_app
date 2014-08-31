FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "Person_#{n}" }
    sequence(:name) { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

  factory :message do
    content "Lorem ipsum"
    sender_id 1
    receiver_id 2
  end
end
