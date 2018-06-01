#scrapes the weather from MetaWeather for our slackbot to use
require 'rest-client'
require 'json'
require 'pry'


def get_weather_for_location(location)
  location_weather = RestClient.get("https://www.metaweather.com/api/location/search/?query=#{location}")
  location_hash = JSON.parse(location_weather)[0]
  state_and_temp = {state: nil, temp: nil}

  if location_hash == nil
    weather_text = "No weather data for #{location}."
    return weather_text
  else
    #woeid is specific id that, when inputted into the URL will return the API for a specific location
    woeid = location_hash["woeid"]
    city_weather = RestClient.get("https://www.metaweather.com/api/location/#{woeid}")
    city_weather_hash = JSON.parse(city_weather)

    #get the state of the weather
    state_and_temp[:state] = city_weather_hash["consolidated_weather"].first["weather_state_name"]
    #get temperature, and convert to fahrenheit
    state_and_temp[:temp] = ((city_weather_hash["consolidated_weather"].first["the_temp"])*(9.0/5.0)+32).round(1)
    location = location.capitalize

    #get state and temp from hash
    state = state_and_temp[:state].downcase
    temp = state_and_temp[:temp]

    case state_and_temp[:state]
    when "Light Rain","Heavy Rain", "Hail", "Sleet", "Snow", "Showers"
      weather_text = "#{location} has #{state}. The temperature is #{temp}°F."
    when "Thunderstorm"
      weather_text = "#{location} is having a #{state}. The temperature is #{temp}°F."
    when "Clear"
      weather_text = "The weather in #{location} is #{state}. The temperature is #{temp}°F."
    when "Light Cloud", "Heavy Cloud"
      weather_text = "#{location} has #{state}s. The temperature is #{temp}°F."
    end
    weather_text
  end
end
