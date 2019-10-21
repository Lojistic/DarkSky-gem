require './lib/darksky_weather/api.rb'
DarkskyWeather::Api.configure{|c| c.api_key = "cde487d8cd67cb9005f24bad48aa7bca" }

client = DarkskyWeather::Api::Client.new

weather1 = client.get_weather(lat: 37.8267, lng: -122.4233, timestamp: 3.days.ago.to_i)
weather2 = client.get_weather(lat: 37.8267, lng: -122.4233, timestamp: 2.days.ago.to_i)
weather3 = client.get_weather(lat: 37.8267, lng: -122.4233, timestamp: 1.days.ago.to_i)

collection = DarkskyWeather::Api::WeatherCollection.new(weather1, weather2, weather3)


s = 67.hours.ago.to_i
e = 51.hours.ago.to_i

hours = collection.weather_between(s, e)

p collection.max_temperature(hours)
p collection.max_temperature

