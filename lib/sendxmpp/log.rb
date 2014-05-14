require 'logger'
module Sendxmpp
  class Log < Logger
    include Config
    attr_accessor :logger_ins

    def self.logger
      @logger ||= self.new
    end

    def initialize
      if config.logfile
        super(config.logfile)
      else
        super(STDOUT)
      end
      self.level = config.loglevel.to_i || 2
    end
  end
end
