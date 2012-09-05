require "logger"

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

require "gumbo/version"
require "gumbo/asset_builder"
require "gumbo/asset_file"
require "gumbo/asset_package"
require "gumbo/coffee_script_file"
