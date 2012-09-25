require 'optparse'

module Gumbo
  class CLI
    def self.run(args)
      new(args).run
    end

    attr_accessor :options

    def initialize(args)
      @options = {}

      #TODO: Add options for source_dir, output_dir, etc.
      OptionParser.new do |opts|
        opts.banner = "Usage: gumbo [options]"

        opts.on("-c", "--clean", "Delete the output directory before running") do |v|
          @options[:clean] = v
        end
      end.parse(args)
    end

    def run
      Gumbo::AssetBuilder.build(@options)
    end
  end
end
