#Tasks

class Task < ActiveRecord::Base
  has_many :user_tasks
  has_many :users, through: :user_tasks
  belongs_to :task_type

  def self.pretty_task_list(task_list, real_name)
    str = "#{real_name}'s List\n"
    task_list.each_with_index do |task, dex|
      str << "#{dex+1}" + ". #{task}\n"
    end
    str
  end
end
