require 'spec_helper'

RSpec.describe DarkskyWeather::Api::WeatherData do
  let(:fixture_path){ File.expand_path("#{File.dirname(__FILE__)}/../../fixtures/") }
  let(:raw_data){ JSON.parse(File.read("#{fixture_path}/darksky_response.json")) }
  let(:lat) { 33.6892651 }
  let(:lng) { -117.8828102 }
  let(:timestamp) { Date.new(2019, 1, 1).to_time.to_i }
  let(:source_url) { "https://api.darksky.net/boguskey/#{lat},#{lng},#{timestamp}" }

  describe "#new" do
    it "extracts important information from the raw data" do
      wd = DarkskyWeather::Api::WeatherData.new(timestamp, source_url, raw_data)

      expect(wd.latitude).to eq(raw_data['latitude'])
      expect(wd.longitude).to eq(raw_data['longitude'])
      expect(wd.offset).to eq(raw_data['offset'])
      expect(wd.timezone).to eq(raw_data['timezone'])
      expect(wd.sources).to eq(raw_data['flags']['sources'])
    end
  end

  describe "#currently" do
    it "wraps data about current weather conditions" do
      wd = DarkskyWeather::Api::WeatherData.new(timestamp, source_url, raw_data)
      currently = wd.currently
      raw_currently = raw_data['currently']

      expect(currently.apparent_temperature).to eq raw_currently['apparentTemperature']
      expect(currently.cloud_cover).to eq raw_currently['cloudCover']
      expect(currently.dew_point).to eq raw_currently['dewPoint']
      expect(currently.humidity).to eq raw_currently['humidity']
      expect(currently.icon).to eq raw_currently['icon']
      expect(currently.ozone).to eq raw_currently['ozone']
      expect(currently.precip_intensity).to eq raw_currently['precipIntensity']
      expect(currently.precip_probability).to eq raw_currently['precipProbability']
      expect(currently.pressure).to eq raw_currently['pressure']
      expect(currently.summary).to eq raw_currently['summary']
      expect(currently.temperature).to eq raw_currently['temperature']
      expect(currently.time).to eq raw_currently['time']
      expect(currently.uv_index).to eq raw_currently['uvIndex']
      expect(currently.visibility).to eq raw_currently['visibility']
      expect(currently.wind_bearing).to eq raw_currently['windBearing']
      expect(currently.wind_gust).to eq raw_currently['windGust']
      expect(currently.wind_speed).to eq raw_currently['windSpeed']
    end
  end

  describe "#daily" do
    it "wraps data about daily average weather conditions" do
      wd = DarkskyWeather::Api::WeatherData.new(timestamp, source_url, raw_data)
      daily = wd.daily.first
      raw_daily = raw_data['daily']['data'].first

      expect(daily.apparent_temperature_high).to eq raw_daily['apparentTemperatureHigh']
      expect(daily.apparent_temperature_high_time).to eq raw_daily['apparentTemperatureHighTime']
      expect(daily.apparent_temperature_low).to eq raw_daily['apparentTemperatureLow']
      expect(daily.apparent_temperature_low_time).to eq raw_daily['apparentTemperatureLowTime']
      expect(daily.apparent_temperature_max).to eq raw_daily['apparentTemperatureMax']
      expect(daily.apparent_temperature_max_time).to eq raw_daily['apparentTemperatureMaxTime']
      expect(daily.apparent_temperature_min).to eq raw_daily['apparentTemperatureMin']
      expect(daily.apparent_temperature_min_time).to eq raw_daily['apparentTemperatureMinTime']
      expect(daily.cloud_cover).to eq raw_daily['cloudCover']
      expect(daily.dew_point).to eq raw_daily['dewPoint']
      expect(daily.humidity).to eq raw_daily['humidity']
      expect(daily.icon).to eq raw_daily['icon']
      expect(daily.moon_phase).to eq raw_daily['moonPhase']
      expect(daily.ozone).to eq raw_daily['ozone']
      expect(daily.precip_intensity).to eq raw_daily['precipIntensity']
      expect(daily.precip_intensity_max).to eq raw_daily['precipIntensityMax']
      expect(daily.precip_probability).to eq raw_daily['precipProbability']
      expect(daily.pressure).to eq raw_daily['pressure']
      expect(daily.summary).to eq raw_daily['summary']
      expect(daily.sunrise_time).to eq raw_daily['sunriseTime']
      expect(daily.sunset_time).to eq raw_daily['sunsetTime']
      expect(daily.temperature_high).to eq raw_daily['temperatureHigh']
      expect(daily.temperature_high_time).to eq raw_daily['temperatureHighTime']
      expect(daily.temperature_low).to eq raw_daily['temperatureLow']
      expect(daily.temperature_low_time).to eq raw_daily['temperatureLowTime']
      expect(daily.temperature_max).to eq raw_daily['temperatureMax']
      expect(daily.temperature_max_time).to eq raw_daily['temperatureMaxTime']
      expect(daily.temperature_min).to eq raw_daily['temperatureMin']
      expect(daily.temperature_min_time).to eq raw_daily['temperatureMinTime']
      expect(daily.time).to eq raw_daily['time']
      expect(daily.uv_index).to eq raw_daily['uvIndex']
      expect(daily.uv_index_time).to eq raw_daily['uvIndexTime']
      expect(daily.visibility).to eq raw_daily['visibility']
      expect(daily.wind_bearing).to eq raw_daily['windBearing']
      expect(daily.wind_gust).to eq raw_daily['windGust']
      expect(daily.wind_gust_time).to eq raw_daily['windGustTime']
      expect(daily.wind_speed).to eq raw_daily['windSpeed']
    end
  end

  describe "#hourly" do
    it "wraps data about individual hours of weather conditions" do
      wd = DarkskyWeather::Api::WeatherData.new(timestamp, source_url, raw_data)
      hourly    = wd.hourly.first
      raw_hourly = raw_data['hourly']['data'].first

      expect(hourly.cloud_cover).to eq raw_hourly['cloudCover']
      expect(hourly.dew_point).to eq raw_hourly['dewPoint']
      expect(hourly.humidity).to eq raw_hourly['humidity']
      expect(hourly.icon).to eq raw_hourly['icon']
      expect(hourly.ozone).to eq raw_hourly['ozone']
      expect(hourly.precip_intensity).to eq raw_hourly['precipIntensity']
      expect(hourly.precip_probability).to eq raw_hourly['precipProbability']
      expect(hourly.pressure).to eq raw_hourly['pressure']
      expect(hourly.summary).to eq raw_hourly['summary']
      expect(hourly.temperature).to eq raw_hourly['temperature']
      expect(hourly.time).to eq raw_hourly['time']
      expect(hourly.uv_index).to eq raw_hourly['uvIndex']
      expect(hourly.visibility).to eq raw_hourly['visibility']
      expect(hourly.wind_bearing).to eq raw_hourly['windBearing']
      expect(hourly.wind_gust).to eq raw_hourly['windGust']
      expect(hourly.wind_speed).to eq raw_hourly['windSpeed']
    end

  end


end
