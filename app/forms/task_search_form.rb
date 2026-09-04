class TaskSearchForm
  include ActiveModel::Model
    attr_accessor :title, :status, :user

    ALLOWED_STATUS = Task.statuses.keys.freeze

    validates :status, inclusion: { in: ALLOWED_STATUS, message: I18n.t("errors.messages.not_include") }, allow_blank: true

    validates :user, presence: true
    def search
      return Task.none unless valid?
      scope = user.tasks
      scope = scope.where("title LIKE ?", "%#{title}%") if title.present?
      scope = scope.where(status: status) if status.present?
      scope
    end
end
