# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
20.times do |i|
  Task.find_or_create_by!(title: "task#{format('%03d', i+1)}") do |task|
  task.content = Faker::Lorem.paragraph
  task.end_time = Faker::Date.between(from: 5.years.ago, to: Time.current)
  task.created_at = Faker::Date.between(from: 5.years.ago, to: Time.current)
  task.status = Task.statuses.keys.sample
  task.priority = Task.priorities.keys.sample
  end
end
