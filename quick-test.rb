require "bundler/setup"
require "darksky/api"

Darksky::Api.configure{|c| c.api_key = "ebc08b3decdca707b652b20847f8e726" }

client = Darksky::Api::Client.new

#lat, lng, timestamp = [33.7378138,-117.9571878,1544130000]
#lat, lng, timestamp = [40.7319717407227,	-74.1742095947266,	1542669985]
lat, lng, timestamp = [39.1037292480469,	-84.5126724243164,	1542777300]

center_date   = Time.at(timestamp)
ts_b24 = (center_date - 1.day).to_i
ts_b48 = (center_date - 2.day).to_i
ts_b72 = (center_date - 3.day).to_i
day_after_ts = (center_date + 1.day).to_i



data1 = client.get_weather(lat: lat, lng: lng, timestamp: ts_b72)
data2 = client.get_weather(lat: lat, lng: lng, timestamp: ts_b48)
data3 = client.get_weather(lat: lat, lng: lng, timestamp: ts_b24)
data4 = client.get_weather(lat: lat, lng: lng, timestamp: timestamp)
data5 = client.get_weather(lat: lat, lng: lng, timestamp: day_after_ts)

dataset = Darksky::Api::DataSet.new(data1, data2, data3, data4, data5)

p dataset.rainfall.max_from_days(0..4)
p dataset.snow_accumulation.max_from_days(0..4)
p dataset.visibility.min_from_days(0..4)
p dataset.data_sources

