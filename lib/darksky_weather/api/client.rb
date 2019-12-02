require 'httparty'

module DarkskyWeather
  module Api
    class Client
      include HTTParty
      base_uri "https://api.darksky.net/forecast/"

      def get_weather(lat:, lng:, timestamp: nil, opts: {})
        key         = DarkskyWeather::Api.configuration.api_key

        request_path   = "/#{key}/#{lat},#{lng}"
        request_path << ",#{timestamp}" if timestamp

        allowed_opts = %w(extend exclude lang units)
        opts.each_with_index do |o, idx|
          next unless allowed_opts.include?(o.first.to_s)
          sep_sym = idx == 0 ? '?' : '&'
          request_path << "#{sep_sym}#{o.first}=#{o.last}"
        end

        raw_result  = self.class.get(request_path)
        request_uri = raw_result.request.uri.to_s

        return WeatherData.new(timestamp, request_uri, raw_result.parsed_response)
      end
    end
  end
end
