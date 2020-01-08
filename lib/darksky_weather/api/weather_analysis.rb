# A set of methods for analyzing and collating weather data
module DarkskyWeather
  module Api
    module WeatherAnalysis

      # Get the range of hourly weather data that occurred inclusively between start_time and end_time
      def weather_between(start_time, end_time)
        normalized_start = Time.strptime(start_time.to_s, '%s').beginning_of_hour.to_i
        normalized_end   = Time.strptime(end_time.to_s, '%s').beginning_of_hour.to_i

        return hourly.select{|h| h.time.to_i >= normalized_start && h.time.to_i <= normalized_end }.sort_by(&:time)
      end

      # Get the hourly weather data that encompasses the passed time.
      def weather_at(time)
        compare_time = Time.strptime(time.to_s, '%s').beginning_of_hour
        hourly.select{|h| h.time == compare_time.to_i }.first
      end

      def total_precipitation(type: 'rain', hours: hourly)
        hours.select{|h| h.precip_type == type  }.map{|h| h.precip_intensity.to_f }.sum
      end

      def max_precipitation(type: 'rain', hours: hourly)
        hours.select{|h| h.precip_type == type  }.map{|h| h.precip_intensity || 0.0 }.max || 0
      end

      def max_precipitation_datetime(type: 'rain', hours: hourly)
        stamp = hours.select{|h| h.precip_type == type  }.sort_by{|h| h.precip_intensity.to_f }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def max_accumulation(hours: hourly)
        hours.map{|h| h.precip_accumulation || 0.0 }.max || 0
      end

      def max_accumulation_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.precip_accumulation }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def worst_visibility(hours: hourly)
        hours.map{|h| h.visibility || 0.0 }.min || 10
      end

      def worst_visibility_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.visibility }.first.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def best_visibility(hours: hourly)
        hours.map{|h| h.visibility || 0.0 }.max || 10
      end

      def best_visibility_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.visibility }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def average_visibility(hours: hourly)
        visibility_total = hours.map{|h| h.visibility }.sum
        return (visibility_total / hours.count.to_f).to_f
      end

      def max_temperature(hours: hourly)
        hours.map{|h| h.temperature || 0.0 }.max
      end

      def max_temperature_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.temperature }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def min_temperature(hours: hourly)
        hours.map{|h| h.temperature || 0.0 }.min
      end

      def min_temperature_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.temperature }.first.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def max_wind_speed(hours: hourly)
        hours.map{|h| h.wind_speed || 0.0 }.max
      end

      def max_wind_speed_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.wind_speed }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def min_wind_speed(hours: hourly)
        hours.map{|h| h.wind_speed || 0.0 }.min
      end

      def min_wind_speed_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.wind_speed }.first.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

      def average_wind_speed(hours: hourly)
        total_wind_speed = hours.map{|h| h.wind_speed || 0.0 }.sum
        (total_wind_speed / hours.count.to_f).to_f
      end

      def max_wind_gust(hours: hourly)
        hours.map{|h| h.wind_gust || 0.0 }.max
      end

      def max_wind_gust_datetime(hours: hourly)
        stamp = hours.sort_by{|h| h.wind_gust }.last.time
        return DateTime.strptime(stamp.to_s, "%s")
      end

    end
  end
end
