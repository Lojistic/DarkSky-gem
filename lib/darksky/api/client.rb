require 'httparty'

module Darksky
  module Api
    class Client
      include HTTParty
      base_uri "https://api.darksky.net/forecast/"

      def get_weather(lat:, lng:, timestamp:)
        key = Darksky::Api.configuration.api_key
        raw_result = self.class.get("/#{key}/#{lat},#{lng},#{timestamp}")

        parsed = JSON.parse(raw_result.body)

        return WeatherData.new(parsed)
      end
    end
  end
end
