class AssignOrphanTasks < ActiveRecord::Migration[8.1]
  def up
    user = User.find_or_create_by!(email: "orphan@test.test") do |user|
      user.name = "orphan"
      user.password = "123456"
      user.role = "normal"
    end

    Task.where(user_id: nil).update_all(user_id: user.id)
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
