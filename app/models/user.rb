#User

class User < ActiveRecord::Base
  has_many :user_tasks
  has_many :tasks, through: :user_tasks

  def get_tasks(task_type_name)
    usertasks = UserTask.all.select do |usertask|
      usertask.user == self && usertask.task.task_type.name == task_type_name
    end
  end

  def get_task_names(usertasks)
    usertasks.map do |usertask|
      usertask.task.name
    end
  end

  def get_tasks_for_user(task_type_name)
    get_task_names(get_tasks(task_type_name))
  end

  def get_tasks_today(task_type_name)
    tasks_today = get_tasks(task_type_name).select do |ut|
      ut.date_added = Date.current
    end

    get_task_names(tasks_today)
  end

  def self.update_db(user_name, task_name, task_type_name, date_added = Date.current)

     user = User.find_by(name: user_name)
     if !user
       user = User.create(name: user_name)
     end
     task = Task.create(name: task_name)

     taskuser = UserTask.create(user: user, task: task, date_added: date_added)
     task_type = TaskType.find_by(name: task_type_name)
     if !task_type
       task_type = TaskType.create(name: task_type_name)
     end
     task.task_type = task_type
     task.save
  end


  def self.get_real_name(user_id, client)
    #retrieve user specific hash from client hash
    user_hash = client.select do |info|
      info == user_id
    end

    #fetch real user's name from client hash
    rname = user_hash.first[1]["real_name"]
    rname
  end

  def self.get_history(tasktype, real_name)
    tasks = User.find_by(name: real_name).get_tasks_for_user(tasktype)
    droid_out = Task.pretty_task_list(tasks, real_name)
    droid_out
  end

end
