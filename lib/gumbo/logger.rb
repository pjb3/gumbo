require 'logger'

module Gumbo
  def self.logger
    @logger ||= begin
      logger = Logger.new(STDOUT)
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
      logger
    end
  end

  def self.logger=(logger)
    @logger = logger
  end
end
