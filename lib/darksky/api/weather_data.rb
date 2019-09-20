module DarkskyWeather
  module Api
    class WeatherData

      attr_reader :latitude, :longitude, :timestamp, :currently, :minutely, :hourly, :daily, :raw, :flags, :source_url

      def initialize(source_url, json_data)
        @source_url = source_url
        @raw        = json_data
        @latitude   = json_data['latitude']
        @longitude  = json_data['longitude']
        @timestamp  = json_data['currently']['time']

        json_data.each do |k, v|
          instance_variable_set(:"@#{k}", v) if self.respond_to?(k)
        end
      end

      def attributes
        atts = {}
        [ :current_precipitation,
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
          :report_date ].each do |att_name|
            atts[att_name] = self.send(att_name)
          end

          return atts
      end

      def report_date
        DateTime.strptime(currently['time'].to_s,'%s').to_date
      end

      def current_precipitation
        currently['precipIntensity'] || 0
      end

      def current_accumulation
        currently['precipAccumulation'] || 0
      end

      def current_visibility
        currently['visibility'].to_f
      end

      def current_temperature
        currently['temperature'].to_f
      end

      def current_wind_speed
        currently['windSpeed'].to_f
      end

      def current_wind_gust
        currently['windGust'].to_f
      end

      def max_precipitation
        daily['data'].map{|d| d['precipIntensityMax'].to_f }.max || 0
      end

      def max_accumulation
        daily['data'].map{|d| d['precipAccumulation'].to_f }.max || 0
      end

      def worst_visibility
        hourly['data'].map{|d| d['visibility'].to_f }.min
      end

      def max_temperature
        daily['data'].map{|d| d['temperatureMax'].to_f }.max
      end

      def min_temperature
        daily['data'].map{|d| d['temperatureMin'].to_f }.max
      end

      def max_wind_speed
        hourly['data'].map{|d| d['windSpeed'].to_f }.max
      end

      def max_wind_gust
        hourly['data'].map{|d| d['windGust'].to_f }.max
      end

    end
  end
end
