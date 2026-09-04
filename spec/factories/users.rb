FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    email { Faker::Internet.email }
    password { "password" }
    role { "normal" }
  end
end
