require 'set'
require 'yaml'

class Gumbo::AssetBuilder
  DEFAULT_SOURCE_DIR = "assets"
  DEFAULT_OUTPUT_DIR = "public"
  DEFAULT_PACKAGES_FILE = "packages.yml"

  attr_accessor :source_dir, :output_dir, :packages_file

  def initialize(attrs={})
    attrs.each do |k,v|
      send("#{k}=", v)
    end
    self.source_dir ||= DEFAULT_SOURCE_DIR
    self.output_dir ||= DEFAULT_OUTPUT_DIR
    self.packages_file ||= File.join(source_dir, DEFAULT_PACKAGES_FILE)
  end

  def build
    packages_to_rebuild = Set.new

    file_packages.each do |file, packages|
      if file.should_be_rebuilt?
        file.build
        packages.each{|p| packages_to_rebuild << p }
      end
    end

    packages_to_rebuild.each(&:build)

    # non-css, non-js assets, including liquid
  end

  def package_manifests
    @package_manifests ||= YAML.load_file(packages_file)
  end

  def get_package_for(output_dir, package_type, package_name)
    @packages ||= {}
    @packages[package_type] ||= {}
    @packages[package_type][package_name] ||= Gumbo::AssetPackage.new(output_dir, package_type, package_name)
  end

  def file_packages
    @file_packages ||= package_manifests.inject({}) do |file_packages, (package_type, package_manifests)|
      package_manifests.each do |package_name, file_names|
        package = get_package_for(output_dir, package_type, package_name)
        file_names.each do |file_name|
          file = Gumbo::AssetFile.for(source_dir, output_dir, package_type, file_name)
          file_packages[file] ||= []
          file_packages[file] << package
          package.files << file
        end
      end
      file_packages
    end
  end

end
