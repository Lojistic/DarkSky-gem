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
          p hourly[hidx1..hidx2].map{|hd| hd[@query_field].to_f }
          return (hourly[hidx1..hidx2].map{|hd| hd[@query_field].to_f }.sum) #/ hourly[hidx1..hidx2].length).precision(2)


        else
          return hourly[hidx1..hidx2]
        end
      end

      private

      def hourly
        @weather_datas.map(&:hourly).flatten.map{|h| h['data'] }.flatten
      end

    end
  end
end
