require "darksky/api/version"
require "darksky/api/client"
require "darksky/api/weather_data"
require "darksky/api/data_set"
require "active_support/time"

module Darksky
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
