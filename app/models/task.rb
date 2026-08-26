class Task < ApplicationRecord
  enum :status, { pending: :pending, in_progress: :in_progress, completed: :completed }, default: :pending

  ALLOWED_COLUMNS = [ "end_time", "created_at" ]

  # sort
  scope :sorted_by, ->(column:, direction: :ASC) {
    column = "created_at" unless ALLOWED_COLUMNS.include?(column.to_s)
    direction = :ASC unless %i[ASC DESC].include?(direction.to_s.upcase.to_sym)
    order(column => direction) }



  validates :title, presence: { message: I18n.t("errors.messages.blank") }
  validates :end_time, presence: { message: I18n.t("errors.messages.blank") }
end
