module Darksky
  module Api
    class WeatherData

      attr_reader :latitude, :longitude, :timezone, :currently, :minutely, :hourly, :daily, :raw

      def initialize(json_data)
        @raw = json_data
        json_data.each do |k, v|
          instance_variable_set(:"@#{k}", v) if self.respond_to?(k)
        end
      end

    end
  end
end

# Rain, snow, visibility, data sources
