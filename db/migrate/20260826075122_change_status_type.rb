class ChangeStatusType < ActiveRecord::Migration[8.1]
  def change
        change_column :tasks, :status, :string
        change_column :tasks, :priority, :string
  end
end
