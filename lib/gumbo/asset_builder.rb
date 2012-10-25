require 'fileutils'
require 'json'
require 'set'
require 'time'
require 'yaml'

module Gumbo
  class AssetBuilder
    DEFAULT_SOURCE_DIR = "assets"
    DEFAULT_OUTPUT_DIR = "public"
    DEFAULT_PACKAGES_FILE = "packages.yml"
    DEFAULT_MANIFEST_FILE = "packages.json"

    attr_accessor :source_dir, :output_dir, :packages_file, :manifest_file, :clean

    def self.build(attrs={})
      new(attrs).build
    end

    def initialize(attrs={})
      self.clean = !!attrs[:clean]
      self.source_dir = attrs.fetch(:source_dir, DEFAULT_SOURCE_DIR)
      self.output_dir = attrs.fetch(:output_dir, DEFAULT_OUTPUT_DIR)
      self.packages_file = File.join(source_dir, attrs.fetch(:packages_file, DEFAULT_PACKAGES_FILE))
      self.manifest_file = File.join(output_dir, attrs.fetch(:manifest_file, DEFAULT_MANIFEST_FILE))
    end

    def build
      clean_output_dir if clean
      create_output_dir
      build_package_files
      build_packages
      build_non_package_files
    end

    protected

    def clean_output_dir
      FileUtils.rm_r(output_dir) if File.exists?(output_dir)
    end

    def create_output_dir
      FileUtils.mkdir_p(output_dir)
    end

    def build_package_files
      file_packages.each do |file, packages|
        package_files << file.source_file
        if file.should_be_rebuilt?
          file.build
          packages.each{|p| packages_to_rebuild << p }
        end
      end
    end

    def build_packages
      unless packages_to_rebuild.empty?
        packages_to_rebuild.each do |package|
          package.build
          asset_packages[package.type] ||= {}
          asset_packages[package.type][package.name] = package.file_name
        end

        new_manifest = File.exists?(manifest_file)
        open(manifest_file, "w") do |f|
          f << JSON.pretty_generate(asset_packages)
          logger.info "#{new_manifest ? 'Created' : 'Updated'} #{manifest_file}"
        end
      end
    end

    def build_non_package_files
      Dir["#{source_dir}/**/*"].each do |file|
        unless File.directory?(file) || file == packages_file || package_files.include?(file)
          asset_file = AssetFile.for(
            :name => file.sub(/^#{source_dir}\//, ''),
            :source_dir => source_dir,
            :output_dir => output_dir,
            :context => {
              "asset_packages" => asset_packages
            })
          if !packages_to_rebuild.empty? || asset_file.should_be_rebuilt?
            asset_file.build
          end
        end
      end
    end

    # A Set of AssetPackage objects which need to be rebuilt
    def packages_to_rebuild
      @packages_to_rebuild ||= Set.new
    end

    # A Set of file names of all files that are part of at least one package
    def package_files
      @package_files ||= Set.new
    end

    # A Hash of package types to Hashes of package names to package file
    # Example:
    #   {
    #     "js" => {
    #       "foo" => "foo-cff07015305f5bc4ffc30a216a676df2.js"
    #     }
    #   }
    def asset_packages
      @asset_packages ||= if File.exists?(manifest_file)
        parse_file(manifest_file)
      else
        {}
      end
    end

    # The definition of which files are in each package
    # as parsed from the packages_file
    def package_definitions
      @package_definitions ||= parse_file(packages_file)
    end

    # Given a package_type and package_name, this will return
    # the AssetPackage object representing those values,
    # returning the same object on successive calls for the same
    # package_type and package_name
    def get_package_for(output_dir, package_type, package_name)
      @packages ||= {}
      @packages[package_type] ||= {}
      @packages[package_type][package_name] ||= AssetPackage.new(
        :output_dir => output_dir,
        :type => package_type,
        :name => package_name)
    end

    # A Hash of AssetFile to an Array of AssetPackage objects,
    # representing the AssetPackages that an AssetFile belongs to
    def file_packages
      @file_packages ||= package_definitions.inject({}) do |file_packages, (package_type, package_definitions)|
        package_definitions.each do |package_name, file_names|
          package = get_package_for(output_dir, package_type, package_name)
          file_names.each do |file_name|
            file = PackageFile.for(
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

    private

    def logger
      Gumbo.logger
    end

    def parse_file(file)
      case File.extname(file)
      when '.yml', '.yaml' then YAML.load_file(file)
      when '.json' then JSON.parse(File.read(file))
      else raise "Unknown file type: #{file}"
      end
    end

  end
end
