# Module One Final Project "Droid Bot"

## Overview
Droid Bot implements a bot named "Droid" in Slack.  Droid can respond to requests for weather or stock quotes, build a to-do list, or run a timer.

Weather is provided by https://www.metaweather.com/api/
Stock quotes are provided by https://www.alphavantage.co/documentation/#time-series-data

The interaction with Droid is accumulated in a database, as shown in model.jpg.  Droid knows the stock quotes, weather, and to-do items for each user.  The current to-do list is displayed each time an item is added.  Each day the to-do list starts over. 

## Implementing a Slack Bot
It is recommended that you create a new Workspace for your bot.
Then create an app here https://api.slack.com/apps
Create a bot user (which is within your app)
Install the app in your workspace
Copy the Bot User OAuth Access Token and exported it to your environment
	export SLACK_API_TOKEN= <your api token>

Code examples for various types of bots may be found here: https://github.com/slack-ruby/slack-ruby-bot

## Droid Interaction
Droid responds to the following requests:
Weather in <city>
Quote <stock symbol>
TODO: <your to do item>
Timer: <number of seconds>

A user may also see the history of their interactions by asking Droid:
Weather history
Quote history
TODO history

