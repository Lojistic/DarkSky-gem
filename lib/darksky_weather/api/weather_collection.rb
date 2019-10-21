# Given a set of WeatherData objects, merge, normalize and aggregate data points for analysis purposes

module DarkskyWeather
  module Api
    class WeatherCollection
      include WeatherAnalysis

      attr_reader :start_date, :end_date, :daily, :hourly, :minutely

      def initialize(*weather_datas)
        @weather_datas = weather_datas

        normalize_timestamps
        normalize_data
      end

      private

      def normalize_data(*args)
        daily    = []
        hourly   = []
        minutely = []

        @weather_datas.map do |wd|
          hourly << wd.hourly.map(&:to_h) if wd.hourly
          daily << wd.daily.to_h if wd.daily
          minutely << wd.minutely.map(&:to_h) if wd.minutely
        end

        ds, hs, ms = [daily.compact, hourly.compact, minutely.compact].map(&:flatten!).map do |arr|
          arr.map{|hsh| OpenStruct.new(hsh) }.sort_by{|s| s.time }.reverse if arr
        end

        @daily    = ds
        @hourly   = hs
        @minutely = ms
      end

      def normalize_timestamps
        start_timestamp = @weather_datas.sort_by{|wd| wd.timestamp }.first.timestamp
        end_timestamp   = @weather_datas.sort_by{|wd| wd.timestamp }.last.timestamp
        @start_date     = DateTime.strptime(start_timestamp.to_s, "%s").to_date
        @end_date       = DateTime.strptime(end_timestamp.to_s, "%s").to_date
      end

    end
  end
end
