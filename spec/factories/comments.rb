FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    association :user
    association :article
  end
end
