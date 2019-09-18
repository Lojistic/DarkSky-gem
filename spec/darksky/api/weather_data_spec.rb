require 'spec_helper'

RSpec.describe Darksky::Api::WeatherData do

  let(:fixture_path){ File.expand_path("#{File.dirname(__FILE__)}/../../fixtures/") }
  let(:raw_data){ File.read("#{fixture_path}/darksky_response.json") }
  let(:lat) { 33.6892651 }
  let(:lng) { -117.8828102 }
  let(:timestamp) { Date.new(2019, 1, 1).to_time.to_i }
  let(:source_url) { "https://api.darksky.net/boguskey/#{lat},#{lng},#{timestamp}" }

  describe "#new" do

    it "parses raw JSON responses" do
      parsed_raw   = JSON.parse(raw_data)
      weather_data = Darksky::Api::WeatherData.new(source_url, parsed_raw)

      expect(weather_data.currently).to eq(parsed_raw['currently'])
      expect(weather_data.minutely).to eq(parsed_raw['minutely'])
      expect(weather_data.hourly).to eq(parsed_raw['hourly'])
      expect(weather_data.daily).to eq(parsed_raw['daily'])
      expect(weather_data.flags).to eq(parsed_raw['flags'])
    end
  end

  describe "#attributes" do

    it "returns a hash of relevant weather data" do
      parsed_raw   = JSON.parse(raw_data)
      weather_data = Darksky::Api::WeatherData.new(source_url, parsed_raw)

      attributes = weather_data.attributes

      keys = [
                :current_precipitation,
                :current_accumulation,
                :current_visibility,
                :current_temperature,
                :current_wind_speed,
                :current_wind_gust,
                :max_precipitation,
                :max_accumulation,
                :worst_visibility,
                :max_temperature,
                :min_temperature,
                :max_wind_speed,
                :max_wind_gust,
                :report_date
      ]

      keys.each do |k|
        expect(attributes).to have_key(k)
      end
    end
  end

end
