module DarkskyWeather
  module Api
    class WeatherData
      include WeatherAnalysis

      attr_reader :latitude, :longitude, :offset, :timezone, :timestamp, :sources, :raw

      def initialize(timestamp, source_url, raw)
        @timestamp  = timestamp
        @source_url = source_url
        @raw        = raw

        @latitude  = raw['latitude']
        @longitude = raw['longitude']
        @offset    = raw['offset']
        @timezone  = raw['timezone']
        @sources   = raw['flags']['sources']
      end

      def currently
        return nil unless @raw['currently']
        return OpenStruct.new(@raw['currently'].deep_transform_keys{|k| k.underscore })
      end

      def daily
        return nil unless @raw['daily']
        @raw['daily']['data'].map do |hsh|
          OpenStruct.new(hsh.deep_transform_keys{|k| k.underscore })
        end
      end

      def hourly
        return nil unless @raw['hourly']
        @raw['hourly']['data'].map do |hsh|
          OpenStruct.new(hsh.deep_transform_keys{|k| k.underscore })
        end
      end

      def minutely
        return nil unless @raw['minutely']
        @raw['minutely']['data'].map do |hsh|
          OpenStruct.new(hsh.deep_transform_keys{|k| k.underscore })
        end
      end

    end
  end
end
