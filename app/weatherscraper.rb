#scrapes the weather from MetaWeather for our slackbot to use
require 'rest-client'
require 'json'
require 'pry'


def get_weather_for_location(location)
  location_weather = RestClient.get("https://www.metaweather.com/api/location/search/?query=#{location}")
  location_hash = JSON.parse(location_weather)[0]
  state_and_temp = {state: nil, temp: nil}

  if location_hash == nil
    state_and_temp[:state] = "No weather data"
    state_and_temp[:temp] = nil
    return state_and_temp
  else
    woeid = location_hash["woeid"]
    city_weather = RestClient.get("https://www.metaweather.com/api/location/#{woeid}")
    city_weather_hash = JSON.parse(city_weather)

    state_and_temp[:state] = city_weather_hash["consolidated_weather"].first["weather_state_name"]
    #get temperature, and convert to fahrenheit
    state_and_temp[:temp] = ((city_weather_hash["consolidated_weather"].first["the_temp"])*(9.0/5.0)+32).round(1)

    state_and_temp
  end
end
