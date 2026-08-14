class Task < ApplicationRecord
  scope :sorted_by, ->(column:, direction: :ASC) { order(column => direction) }
end
