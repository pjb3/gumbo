require 'coffee_script'

module Gumbo
  class CoffeeScriptFile < CompileToJavaScriptFile
    ext ".coffee"

    def build
      logger.info "#{source_file} -> #{output_file}"
      mkdir_p File.dirname(output_file)
      open(output_file, 'w') do |out|
        out << CoffeeScript.compile(File.read(source_file))
      end
    end
  end
end
