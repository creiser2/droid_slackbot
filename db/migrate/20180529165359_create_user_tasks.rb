class CreateUserTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tasks do |s|
      s.string :name
      s.integer :user_id
      s.integer :task_id
    end
  end
end
