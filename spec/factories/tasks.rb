FactoryBot.define do
  factory :task do
    title { "test" }
    content { "test" }
    created_at { Time.zone.now }
    end_time { 1.day.from_now }
  end
end
