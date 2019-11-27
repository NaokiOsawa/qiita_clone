FactoryBot.define do
  factory :article do
    body { Faker::Lorem.paragraph }
    title { Faker::Lorem.characters }
  end
end
