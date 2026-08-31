FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    created_at { Time.zone.now }
    status { Task.statuses.keys.sample }
    end_time { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    priority { Task.priorities.keys.sample }
  end
end
