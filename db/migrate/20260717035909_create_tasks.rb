class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.integer :task
      t.integer :priority
      t.integer :user_id

      t.timestamps
    end
  end
end
