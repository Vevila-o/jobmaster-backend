class RenameColumnTaskToStatus < ActiveRecord::Migration[8.1]
  def change
    rename_column :tasks, :task, :status
  end
end
