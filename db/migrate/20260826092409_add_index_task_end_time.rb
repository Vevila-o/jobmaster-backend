class AddIndexTaskEndTime < ActiveRecord::Migration[8.1]
  def change
    add_index :tasks, :end_time
  end
end
