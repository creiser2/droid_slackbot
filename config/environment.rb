require 'pry'
require 'bundler'
require 'active_record'
require 'slack-ruby-bot'
require_relative '../app/weatherscraper.rb'
require_relative '../app/stockscraper.rb'
require_relative '../app/models/usertask.rb'
require_relative '../app/models/user.rb'
require_relative '../app/models/task.rb'
require_relative '../app/models/task_type.rb'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/slackbot.db')
# require_all 'lib'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil 
