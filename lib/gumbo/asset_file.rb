require 'fileutils'

class Gumbo::AssetFile
  attr_accessor :source_dir, :output_dir, :type, :name
  include FileUtils

  def self.for(source_dir, output_dir, type, name)
    class_for(name).new(source_dir, output_dir, type, name)
  end

  def self.class_for(name)
    case File.extname(name)
    when ".coffee" then Gumbo::CoffeeScriptFile
    else self
    end
  end

  def initialize(source_dir, output_dir, type, name)
    self.source_dir = source_dir
    self.output_dir = output_dir
    self.type = type
    self.name = name
  end

  def source_file
    @source_file ||= File.join(source_dir, type, name)
  end

  def output_file
    @output_file ||= File.join(output_dir, type, name)
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
