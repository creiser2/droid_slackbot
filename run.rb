require_relative 'config/environment.rb'

# tony = User.create(name: "Tony")
# greg = User.create(name: "Greg")


types = []
types << stockquote_type = TaskType.create(name: "Stock Quote")
types << weather_type = TaskType.create(name: "Weather")
types << todo_type = TaskType.create(name: "ToDo")

puts "Welcome"
puts "What is your name?"

username = gets.chomp

puts "Hi #{username}. Please select from the list below"

types.each_with_index do |type, dex|
  puts "#{dex+1}. #{type.name}"
end

choice = gets.to_i

task = Task.create(name: "something", task_type: types[choice-1])

if !User.find_by(name: username)
  user = User.create(name: username)
else
  user = User.find_by(name: username)
end

ut = UserTask.create(name: "Your Task", user: user, task: task)



# stockquote_greg = Task.create(name: "Stock Quote", task_type: stockquote_type)
# weather_greg = Task.create(name: "Weather", task_type: weather_type)
# todo_type_greg = Task.create(name: "ToDo", task_type: todo_type)
#
# UserTask.create(name: "Stock Quote Greg", user: greg, task: stockquote_greg)
# UserTask.create(name: "Weather Greg", user: greg, task: weather_greg)
# UserTask.create(name: "Todo Greg", user: greg, task: todo_type_greg)
#
# stockquote_tony = Task.create(name: "Stock Quote", task_type: stockquote_type)
# weather_tony = Task.create(name: "Weather", task_type: weather_type)
# todo_type_tony = Task.create(name: "ToDo", task_type: todo_type)
#
# UserTask.create(name: "Stock Quote Greg", user: tony, task: stockquote_tony)
# UserTask.create(name: "Weather Greg", user: tony, task: weather_tony)
# UserTask.create(name: "Todo Greg", user: tony, task: todo_type_tony)


binding.pry
true
