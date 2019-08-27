module Darksky
  module Api
    class DataSet

      def initialize(*weather_datas)
        @weather_datas = weather_datas
      end

      def snow_accumulation
        @query_field = 'precipAccumulation'
        return self
      end

      def rainfall
        @query_field = 'precipIntensity'
        return self
      end

      def visibility
        @query_field = 'visibility'
        return self
      end


      def from_hour(hour_index)
        raise "Minimum index is 0, Maximum index is #{hourly.length - 1}" unless hourly_index.between?(0, (hourly.length - 1))

        if @query_field
          return hourly[hour_index][@query_field]
        else
          return hourly[hour_index]
        end
      end

      def between_hours(hidx1, hidx2)
        raise "Minimum index is 0, Maximum index is #{hourly.length - 1}" unless hidx1.between?(0, hourly.length - 1) && hidx2.between?(0, hourly.length - 1)


        if @query_field
          return ((hourly[hidx1..hidx2].map{|hd| hd[@query_field].to_f }.sum) / hourly[hidx1..hidx2].length).precision(2)
        else
          return hourly[hidx1..hidx2]
        end
      end

      def max_from_days(range)
        raise "No field selected." unless @query_field
        max_field = @query_field == 'precipAccumulation' ?  @query_field + "Max" : @query_field

        return daily[range].flatten.map{|d| d[max_field].to_f }.max
      end

      def min_from_days(range)
        raise "No field selected." unless @query_field
        min_field = @query_field == 'precipAccumulation' ?  @query_field + "Max" : @query_field

        return daily[range].flatten.map{|d| d[min_field].to_f }.min
      end

      def data_sources
        @weather_datas.map(&:flags).map{|fd| fd['sources'] }.flatten.uniq.join("; ")
      end

      private

      def hourly
        @weather_datas.map(&:hourly).flatten.map{|h| h['data'] }.flatten
      end

      def daily
        @weather_datas.map(&:daily).map{|d| d['data'] }
      end

    end
  end
end
