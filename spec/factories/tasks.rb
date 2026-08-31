FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "task#{n}" }
    content { Faker::Lorem.paragraph }
    created_at { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    status { Task.statuses.keys.sample }
    end_time { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    priority { Task.priorities.keys.sample }
  end
end
