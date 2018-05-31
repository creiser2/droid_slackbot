#DroidBot.rb
require_relative '../config/environment.rb'

class DroidBot < SlackRubyBot::Bot
  help do
    title 'Welcome to the Droid helper bot'
    desc "I can help you figure stuff out."

    command 'Weather in <location>?' do
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

  match(/^weather in (?<location>\w*)/i) do |client, data, match|
    place = data.text[11..data.text.length]
    place = place.capitalize
    state_and_temp = get_weather_for_location(place)

    #get location weather state and temperature in different variables
    state = state_and_temp[:state]
    temp = state_and_temp[:temp]
    failed = false

    case state
    when "Light Rain","Heavy Rain", "Hail", "Sleet", "Snow", "Showers"
      weather_text = "#{place} has #{state.downcase}, the temperature is #{temp}°F."
    when "Thunderstorm"
      weather_text = "#{place} is having a #{state.downcase}, the temperature is #{temp}°F."
    when "Clear"
      weather_text = "The weather in #{place} is #{state.downcase}, the temperature is #{temp}°F."
    when "Light Cloud", "Heavy Cloud"
      weather_text = "#{place} has #{state.downcase}s, the temperature is #{temp}°F."
    else
      weather_text = "#{state} for #{place}."
      failed = true
    end

    if !failed
      real_name = User.get_real_name(data.user, client.users)
      if User.update_db(real_name, weather_text, "Weather")
        client.say(channel: data.channel, text: weather_text)
      else
        client.say(channel: data.channel, text: "db update error")
      end
    else
      client.say(channel: data.channel, text: weather_text)
    end
  end

  match(/(?<topic>\w*) history/i) do |client, data, match|
    #find the history of a specific user's data by topic
    real_name = User.get_real_name(data.user, client.users)

    case match[:topic].downcase
    when "weather"
      #get history method in user class finds the history of a certain person with a certain task type
      droid_out = User.get_history("Weather", real_name)
      client.say(channel: data.channel, text: "#{droid_out}")
    when "quote"
      droid_out = User.get_history("Stock Quote", real_name)
      client.say(channel: data.channel, text: "#{droid_out}")
    when "todo"
      droid_out = User.get_history("ToDo", real_name)
      client.say(channel: data.channel, text: "#{droid_out}")
    else
      client.say(channel: data.channel, text: "I dont know the history of #{match[:topic]}.")
    end
  end

  match(/^Quote (?<stock>\w*)/i) do |client, data, match|
    value = get_stock_value(match[:stock])
    if !value
      client.say(channel: data.channel, text: "No quote found for #{match[:stock]}.")
    else
      value = value.to_f.round(2)
      task_name = "#{match[:stock]} is at $#{value}"
      real_name = User.get_real_name(data.user, client.users)
      if User.update_db(real_name, task_name, "Stock Quote")
        client.say(channel: data.channel, text: task_name)
      else
        client.say(channel: data.channel, text: "db update error")
      end
    end
  end

  match(/^TODO: (?<TODO>\w*)/i) do |client, data, match|
    todo = data.text[6..data.text.length]
    real_name = User.get_real_name(data.user, client.users)
    if User.update_db(real_name, todo, "ToDo")
      formatted_tasks_from_user = User.find_by(name: real_name).get_tasks_for_user("ToDo")
      droid_out = Task.pretty_task_list(formatted_tasks_from_user, real_name)
      client.say(channel: data.channel, text: "#{droid_out}")
    else
      client.say(channel: data.channel, text: "db update error")
    end
  end

  match(/^TIMER: (?<time>\w*)/i) do |client, data, match|
    time = match[:time].to_i
    while time > 0
      client.say(channel: data.channel, text: "#{time}")
      sleep(1)
      time -= 1
    end
    client.say(channel: data.channel, text: "Times up!")
  end
end


DroidBot.run
