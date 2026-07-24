# 修改role的輸入型別. int >> string
class ChangeUserRole < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :role, :string
  end
end
