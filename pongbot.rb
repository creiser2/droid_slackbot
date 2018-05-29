#pongbot.rb
require 'slack-ruby-bot'
require 'pry'

DROID_TODO = "I have your TODO list right here. What would you like me to do with it?? \n1. View List\n2. Add to List\n3. Delete From List"
class PongBot < SlackRubyBot::Bot
  command 'droid' do |client, data, match|
    client.say(text: "What do you want?!", channel: data.channel)
    sleep(2)
    client.say(text: "1. Weather\n 2. Stock\n 3. TODO List", channel: data.channel)
  end
end


PongBot.run
