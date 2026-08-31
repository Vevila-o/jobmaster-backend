class Task < ApplicationRecord
  enum :status, { pending: :pending, in_progress: :in_progress, completed: :completed }, default: :pending
  enum :priority, { high: :high, medium: :medium, low: :low }, default: :low

  ALLOWED_COLUMNS = [ "end_time", "created_at", "priority" ]

  # sort
  scope :sorted_by, ->(column:, direction: :ASC) {
    column = "created_at" unless ALLOWED_COLUMNS.include?(column.to_s)
    direction = :ASC unless %i[ASC DESC].include?(direction.to_s.upcase.to_sym)

    if column == "priority"
    order(Arel.sql("CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END "))
    else
      order(column => direction)
    end
    }



  validates :title, presence: { message: I18n.t("errors.messages.blank") }
  validates :end_time, presence: { message: I18n.t("errors.messages.blank") }
end
