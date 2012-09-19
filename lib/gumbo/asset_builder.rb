require 'set'
require 'time'
require 'yaml'

module Gumbo
  class AssetBuilder
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
      package_files = Set.new

      file_packages.each do |file, packages|
        package_files << file.source_file
        if file.should_be_rebuilt?
          file.build
          packages.each{|p| packages_to_rebuild << p }
        end
      end

      packages_to_rebuild.each(&:build)

      # This needs to be a mapping of package name to package file
      asset_packages = {}

      # non-css, non-js assets, including liquid
      Dir["#{source_dir}/**/*"].each do |file|
        unless File.directory?(file) || file == packages_file || package_files.include?(file)
          AssetFile.build(
            :name => file.split('/').drop(1).join('/'),
            :source_dir => source_dir,
            :output_dir => output_dir,
            :context => {
              "now" => Time.now,
              "asset_packages" => asset_packages
            })
        end
      end
    end

    def package_manifests
      @package_manifests ||= YAML.load_file(packages_file)
    end

    def get_package_for(output_dir, package_type, package_name)
      @packages ||= {}
      @packages[package_type] ||= {}
      @packages[package_type][package_name] ||= AssetPackage.new(
        :output_dir => output_dir,
        :type => package_type,
        :name => package_name)
    end

    def file_packages
      @file_packages ||= package_manifests.inject({}) do |file_packages, (package_type, package_manifests)|
        package_manifests.each do |package_name, file_names|
          package = get_package_for(output_dir, package_type, package_name)
          file_names.each do |file_name|
            file = AssetFile.for(
              :source_dir => source_dir,
              :output_dir => output_dir,
              :type => package_type,
              :name => file_name)
            file_packages[file] ||= []
            file_packages[file] << package
            package.files << file
          end
        end
        file_packages
      end
    end

  end
end
