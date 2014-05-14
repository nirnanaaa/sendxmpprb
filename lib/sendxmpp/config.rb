require 'hashr'
module Sendxmpp

  # Private: This class provides access to the main configuration
  #
  # Should not be used without Config module
  class InternalConfiguration < Hashr

    # Public: Static singleton
    #
    # Gets a singleton object
    def self.config
      @conf ||= self.new
    end

    # Public: Merge new configuration
    #
    # Use Config.update_config instead!
    #
    # Returns nothing
    def self.merge_config(newconfig)
      @conf = self.new(newconfig)
    end
  end

  # Public: Configuration module. Should be included
  #
  # Usage
  #   include Config
  #
  #   def some_method
  #     config.configbla
  #   end
  module Config

    # Public: Gets the configuration from InternalConfiguration
    #
    # Returns a singleton object of InternalConfiguration
    def config
      InternalConfiguration.config
    end

    # Public: Updates the configuration of InternalConfiguration
    #
    def update_config(new)
      InternalConfiguration.merge_config(new)
    end
  end
end
