#pongbot.rb
require 'slack-ruby-bot'
require 'pry'


class PongBot < SlackRubyBot::Bot
  command 'droid' do |client, data, match|
    client.say(text: "What do you want?!", channel: data.channel)
    sleep(2)
    client.say(text: "1. Weather\n 2. Stock\n 3. TODO List", channel: data.channel)
    if command '1' do |client, data, match|
      #weather
    elsif command '2' do |client, data, match|
      #stock
    elsif command '3' do |client, data, match|
      #TO DO
    else
      #quit droid helper
    end
  end
end


PongBot.run
