require "active_support/time"

require File.dirname(__FILE__) + "/api/version"
require File.dirname(__FILE__) + "/api/client"
require File.dirname(__FILE__) + "/api/weather_analysis"
require File.dirname(__FILE__) + "/api/weather_data"
require File.dirname(__FILE__) + "/api/weather_collection"

module DarkskyWeather
  module Api
    class Error < StandardError; end

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield configuration
    end


    class Configuration
      attr_accessor :api_key
    end

  end
end
