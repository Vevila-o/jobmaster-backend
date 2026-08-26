class TaskSearchForm
  include ActiveModel::Model
    attr_accessor :title, :status
    def search
      scope = Task.all
      scope = scope.where("title LIKE ?", "%#{title}%") if title.present?
      scope = scope.where(status: status) if status.present?
      scope
    end
end
