class AlterUserTasks < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_tasks, :name
  end
end
