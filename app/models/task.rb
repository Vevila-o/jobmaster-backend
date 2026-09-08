class Task < ApplicationRecord
  enum :status, { pending: :pending, in_progress: :in_progress, completed: :completed }, default: :pending
  enum :priority, { high: :high, medium: :medium, low: :low }, default: :low

  belongs_to :user, optional: true
  has_many :task_tags
  has_many :tags, through: :task_tags
  after_save :split_task_tag, if: :tags_present?

  ALLOWED_COLUMNS = [ "end_time", "created_at", "priority" ]

  # sort
  scope :sorted_by, ->(column:, direction: :ASC) {
    column = "created_at" unless ALLOWED_COLUMNS.include?(column.to_s)
    direction = :ASC unless %i[ASC DESC].include?(direction.to_s.upcase.to_sym)

    if column == "priority"
      order(Arel.sql("CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END") => direction)
    else
      order(column => direction)
    end
    }

  validates :title, presence: { message: I18n.t("errors.messages.blank") }
  validates :end_time, presence: { message: I18n.t("errors.messages.blank") }

  def tag_names
    tags.pluck(:name).join(", ")
  end

  def tag_names=(names)
    @tag_names = names
  end

  private
  def tags_present?
    @tag_names.present?
  end

  def split_task_tag
    self.tags = @tag_names.split(",").map(&:strip).map { |name| Tag.find_or_create_by(name: name) }
  end
end
