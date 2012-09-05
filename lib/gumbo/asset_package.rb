require 'digest/md5'

class Gumbo::AssetPackage
  attr_accessor :output_dir, :type, :name, :files, :digest

  def initialize(output_dir, type, name)
    self.output_dir = output_dir
    self.type = type
    self.name = name
  end

  def files
    @files ||= Set.new
  end

  def output_file
    @output_file ||= File.join(output_dir, "#{name}-#{digest}.#{type}")
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
