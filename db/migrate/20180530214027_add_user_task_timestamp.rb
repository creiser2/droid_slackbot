class AddUserTaskTimestamp < ActiveRecord::Migration[5.2]
  def change
    add_column :user_tasks, :date_added, :date
  end
end
