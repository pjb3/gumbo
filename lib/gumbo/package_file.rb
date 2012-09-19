module Gumbo
  class PackageFile < AssetFile
    attr_accessor :type

    def source_file
      @source_file ||= File.join(source_dir, type, name)
    end

    def output_file
      @output_file ||= File.join(output_dir, type, name)
    end

    def eql?(o)
      super && o.type == type
    end
    alias == eql?

    def hash
      super ^ type.hash
    end
  end
end
