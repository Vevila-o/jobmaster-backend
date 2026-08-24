class Task < ApplicationRecord
  scope :sorted_by, ->(column:, direction: :ASC) { order(column => direction) }

  validates :title, presence: { message: I18n.t("errors.messages.blank") }
  validates :end_time, presence: { message: I18n.t("errors.messages.blank") }
end
