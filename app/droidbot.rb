#DroidBot.rb
require_relative '../config/environment.rb'

class DroidBot < SlackRubyBot::Bot

  #this will not work in public channels, must be in private app channel
  help do
    title 'Welcome to the Droid helper bot'
    desc "I can help you figure stuff out."

    command 'Weather (in/at/of) <location>?' do
      "Display the weather for your area"
    end

    command 'Quote <stock symbol>' do
      "Display a certain companies' Stock"
    end

    command 'TODO: <new item to add to list>' do
      "Add an item to your TODO list"
    end

    command 'TIMER: <time in seconds>' do
      "Set a timer that decrements in the chat"
    end

    command '<weather/quote/todo> history' do
      "View history of stock quotes, weather, or todo list that you have created"
    end
  end

  match(/(?<topic>\w*) history/i) do |client, data, match|
    #find the history of a specific user's data by topic
    real_name = User.get_real_name(data.user, client.users)
    droid_out = DroidBot.output(match[:topic], real_name)
    client.say(channel: data.channel, text: "#{droid_out}")

  end

  match(/weather (in |at |of )(?<location>.*)/i) do |client, data, match|
    place = match[:location].capitalize
    # state_and_temp = get_weather_for_location(place)
    weather_text = get_weather_for_location(place)

    #if there is no API data for the location, !failed == false
    if !weather_text.include?("No weather data")
      real_name = User.get_real_name(data.user, client.users)

      #check to see if we can do an update on DB
      if User.update_db(real_name, weather_text, "Weather")
        client.say(channel: data.channel, text: weather_text)
      else
        client.say(channel: data.channel, text: "db update error")
      end
    else
      client.say(channel: data.channel, text: weather_text)
    end
  end


  match(/(quote |quote: |stock |stock: |stock of )(?<stock>.*)/i) do |client, data, match|
    #Grab a stock quote from an API
    value = get_stock_value(match[:stock])

    #No value exists, have client respond
    if !value
      client.say(channel: data.channel, text: "No quote found for #{match[:stock]}.")
    else
      #if a value exists, round to 2 decimal places
      value = value.to_f.round(2)
      #get output string under droid out
      droid_out = "#{match[:stock]} is at $#{value}"
      real_name = User.get_real_name(data.user, client.users)

      #if update successful, say droid out
      if User.update_db(real_name, droid_out, "Stock Quote")
        client.say(channel: data.channel, text: droid_out)

      #update failed, prompt chat
      else
        client.say(channel: data.channel, text: "db update error")
      end
    end
  end

  #ToDo: add item to the todo list
  match(/(ToDo: |To Do: |ToDo |To Do )(?<TODO>.*)/i) do |client, data, match|
    #value after 'todo: '
    todo = match[:TODO]
    #the user.get_real_name function parses through client.users,
    #matches with data.user which is some string of chars, and finds the real name of the user.
    real_name = User.get_real_name(data.user, client.users)
    if User.update_db(real_name, todo, "ToDo")
      #formatted_tasks_from_user, comes back as an array ex: ["Walk Dogs","Go to Bed"]
      formatted_tasks_from_user = User.find_by(name: real_name).get_tasks_for_user("ToDo")
      #pretty_task_list takes the array above, and concatenates it to be a readable output for the client to say
      droid_out = Task.pretty_task_list(formatted_tasks_from_user, real_name)
      client.say(channel: data.channel, text: "#{droid_out}")
    else
      client.say(channel: data.channel, text: "db update error")
    end
  end

  #Simple timer method makes bot countdown from user specified number
  match(/^TIMER: (?<time>\w*)/i) do |client, data, match|
    time = match[:time].to_i
    while time > 0
      client.say(channel: data.channel, text: "#{time}")
      sleep(1)
      time -= 1
    end
    client.say(channel: data.channel, text: "Times up!")
  end

  def self.output(topic, real_name)
    if topic == "droid"
      droid_out = "*Weather Requests*\n" + User.get_history("Weather", real_name) + "\n"
      droid_out += "*Stock Quotes*\n" + User.get_history("Stock Quote", real_name) + "\n"
      droid_out += "*To Do*\n" + User.get_history("ToDo", real_name)
      return droid_out
    elsif topic.downcase == "weather"
      droid_out = User.get_history("Weather", real_name)
      return droid_out
    elsif topic.downcase == "quote"
      droid_out = User.get_history("Stock Quote", real_name)
      return droid_out
    else
      droid_out = User.get_history("ToDo", real_name)
      return droid_out
    end
  end

end

DroidBot.run
