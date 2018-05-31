class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |s|
      s.string :name
      s.integer :task_type_id
    end
  end
end
