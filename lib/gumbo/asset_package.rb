require 'digest/md5'

module Gumbo
  class AssetPackage
    attr_accessor :output_dir, :type, :name, :files, :digest

    def initialize(attrs={})
      attrs.each do |k,v|
        send("#{k}=", v)
      end
    end

    def files
      @files ||= Set.new
    end

    def file_name
      @file_name ||= "#{name}-#{digest}.#{type}"
    end

    def output_file
      @output_file ||= File.join(output_dir, file_name)
    end

    def build
      out = ""
      files.each do |file|
        out << File.read(file.output_file)
        out << "\n"
      end

      self.digest = Digest::MD5.hexdigest(out)

      open(output_file, 'w') do |f|
        f << out
      end

      logger.info "Created package #{output_file}"
    end

    def eql?(o)
      o.is_a?(self.class) &&
        o.type == type &&
        o.name == name
    end
    alias == eql?

    def hash
      type.hash ^ name.hash
    end

    def logger
      Gumbo.logger
    end
  end
end
