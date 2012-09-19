module Gumbo
  class TemplateFile < AssetFile

    def output_file
      @output_file ||= super.sub(/\.liquid$/,'')
    end

    def build
      logger.info "#{source_file} -> #{output_file}"
      mkdir_p File.dirname(output_file)
      open(output_file, 'w') do |out|
        parse(File.read(source_file))
        out << render(context)
      end
    end

    def parse(src)
      raise NotImplementedError
    end

    def render(context)
      raise NotImplementedError
    end

  end
end
