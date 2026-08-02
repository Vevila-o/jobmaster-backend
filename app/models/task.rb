class Task < ApplicationRecord
  scope :sorted_by, ->(columne, direction) { order(columne => direction) }
end
