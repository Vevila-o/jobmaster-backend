class ChangeTaskUserIdType < ActiveRecord::Migration[8.1]
  def up
    change_column(:tasks, :user_id, :bigint)
    add_index :tasks, :user_id
    add_foreign_key :tasks, :users
  end
  def down
    remove_foreign_key :tasks, :users
    remove_index :tasks, :user_id
    change_column(:tasks, :user_id, :integer)
  end
end
