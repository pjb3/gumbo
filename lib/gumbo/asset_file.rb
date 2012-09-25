require 'fileutils'

module Gumbo
  class AssetFile
    attr_accessor :source_dir, :output_dir, :name, :context
    include FileUtils

    def self.for(attrs={})
      class_for(attrs[:name]).new(attrs)
    end

    def self.ext(*args)
      @@extension_class_map ||= {}
      if args.size == 1
        @ext = args.first
        @@extension_class_map[@ext] = self
      end
      @ext
    end

    def self.class_for(name)
      @@extension_class_map[File.extname(name)] || self
    end

    def initialize(attrs={})
      attrs.each do |k,v|
        send("#{k}=", v)
      end
    end

    def source_file
      @source_file ||= File.join(source_dir, name)
    end

    def output_file
      @output_file ||= File.join(output_dir, name)
    end

    def build
      logger.info "#{source_file} -> #{output_file}"
      mkdir_p File.dirname(output_file)
      cp source_file, output_file
    end

    def replace_ext(path, ext)
      parts = path.split('.')
      parts.pop
      parts << ext
      parts.join('.')
    end

    def should_be_rebuilt?
      !File.exists?(output_file) || File.mtime(source_file) > File.mtime(output_file)
    end

    def eql?(o)
      o.is_a?(self.class) &&
        o.name == name
    end
    alias == eql?

    def hash
      name.hash
    end

    def logger
      Gumbo.logger
    end
  end
end
