module Gumbo
  class CompileToJavaScriptFile < PackageFile
    def output_file
      @output_file ||= replace_ext(super, "js")
    end

    def build
      logger.info "#{source_file} -> #{output_file}"
      mkdir_p File.dirname(output_file)
      open(output_file, 'w') do |out|
        out << compile(File.read(source_file))
      end
    end

    def compile(src)
      self.class.compile(src)
    end

    def self.compile(src)
      if compiler
        compiler.compile(src)
      else
        raise "no compiler set for #{name}"
      end
    end

    def self.compiler(*args)
      if args.empty?
        @compiler
      else
        @compiler = args.first
      end
    end
  end
end
