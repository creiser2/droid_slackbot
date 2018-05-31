class CreateTaskTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :task_types do |s|
      s.string :name
    end
  end
end
