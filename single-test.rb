require "bundler/setup"
require "darksky/api"

Darksky::Api.configure{|c| c.api_key = "ebc08b3decdca707b652b20847f8e726" }

client = Darksky::Api::Client.new

lat, lng, timestamp = [38.7402061,-90.1677037, Date.new(2019, 8, 12).to_time.to_i]


data = client.get_weather(lat: lat, lng: lng, timestamp: timestamp)

report = []

report << ['Precipitation', data.current_precipitation]
report << ['Max Precipitation', data.max_precipitation]
report << ['Accumulation', data.current_accumulation]
report << ['Max Accumulation', data.max_accumulation]
report << ['Visibility', data.current_visibility]
report << ['Worst Visibility', data.worst_visibility]
report << ['Temperature High', data.max_temperature]
report << ['Temperature Low', data.min_temperature]
report << ['Wind Speed High', data.max_wind_speed]
report << ['Wind Gust High', data.max_wind_gust]

p data.source_url
pp report


