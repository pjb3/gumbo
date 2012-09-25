require 'optparse'

module Gumbo
  class CLI

    attr_accessor :options

    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: gumbo [options]"

        opts.on("-c", "--clean", "Delete the output directory before running") do |v|
          @options[:clean] = v
        end

        opts.on("-h", "--help", "Display this message") do |h|
          puts opts
          exit
        end

        opts.on("-s", "--source-dir [SOURCE_DIR]", "the source directory, defaults to '#{Gumbo::AssetBuilder::DEFAULT_SOURCE_DIR}'") do |v|
          @options[:source_dir] = v
        end

        opts.on("-o", "--output-dir [OUTPUT_DIR]", "the output directory, defaults to '#{Gumbo::AssetBuilder::DEFAULT_OUTPUT_DIR}'") do |v|
          @options[:output_dir] = v
        end

        opts.on("-p", "--packages-file [PACKAGES_FILE]", "the packages file, relative to the source directory, defaults to '#{Gumbo::AssetBuilder::DEFAULT_PACKAGES_FILE}'") do |v|
          @options[:packages_file] = v
        end

        opts.on("-m", "--manifest-file [MANIFEST_FILE]", "the manifest file, relative to the output directory, defaults to '#{Gumbo::AssetBuilder::DEFAULT_MANIFEST_FILE}'") do |v|
          @options[:manifest_file] = v
        end
      end.parse(args)
    end

    def run
      Gumbo::AssetBuilder.build(@options)
    end
  end
end
