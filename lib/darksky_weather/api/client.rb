require 'httparty'

module DarkskyWeather
  module Api
    class Client
      include HTTParty
      base_uri "https://api.darksky.net/forecast/"

      def get_weather(lat:, lng:, timestamp: nil)
        key         = DarkskyWeather::Api.configuration.api_key

        request_path   = "/#{key}/#{lat},#{lng}"
        request_path << ",#{timestamp}" if timestamp

        raw_result  = self.class.get(request_path)
        request_uri = raw_result.request.uri.to_s

        return WeatherData.new(timestamp, request_uri, raw_result.parsed_response)
      end
    end
  end
end
