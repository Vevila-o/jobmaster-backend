class TaskSearchForm
  include ActiveModel::Model
    attr_accessor :title, :status
    ALLOWED_STATUS = Task.statuses.keys.freeze

    validates :status, inclusion: { in: ALLOWED_STATUS, message: I18n.t("errors.messages.not_include") }, allow_blank: true
    def search
      return Task.none unless valid?
      scope = Task.all
      scope = scope.where("title LIKE ?", "%#{title}%") if title.present?
      scope = scope.where(status: status) if status.present?
      scope
    end
end
