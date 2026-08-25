FactoryBot.define do
  factory :user do
    name { "test" }
    email { Faker::Internet.email }
    password { "password" }
    role { "normal" }
  end
end
