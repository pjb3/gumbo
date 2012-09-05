require 'coffee_script'

class Gumbo::CoffeeScriptFile < Gumbo::AssetFile
  def output_file
    @output_file ||= replace_ext(super, "js")
  end

  def build
    logger.info "#{source_file} -> #{output_file}"
    mkdir_p File.dirname(output_file)
    open(output_file, 'w') do |out|
      out << CoffeeScript.compile(File.read(source_file))
    end
  end
end
