FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    account { Faker::Internet.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
  end
end
