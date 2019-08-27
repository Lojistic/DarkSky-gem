require 'httparty'

module Darksky
  module Api
    class Client
      include HTTParty
      base_uri "https://api.darksky.net/forecast/"

      def get_weather(lat:, lng:, timestamp:)
        key         = Darksky::Api.configuration.api_key
        raw_result  = self.class.get("/#{key}/#{lat},#{lng},#{timestamp}")
        request_uri = raw_result.request.uri.to_s

        return WeatherData.new(request_uri, raw_result.parsed_response, lat, lng, timestamp)
      end
    end
  end
end
