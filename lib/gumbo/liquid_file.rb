require 'liquid'

module Gumbo
  class LiquidFile < TemplateFile
    ext ".liquid"

    def parse(src)
      @template = Liquid::Template.parse(src)
    end

    def render(context)
      @template.render(context)
    end

    class AssetPackageTag < Liquid::Tag
      def initialize(tag_name, file_name, tokens)
         super
         @file_name = file_name
      end

      def render(context)
        parts = @file_name.split('.')
        ext = parts.pop.strip
        name = parts.join('.')
        context["asset_packages"][ext][name]
      end
    end

    Liquid::Template.register_tag("asset_package", AssetPackageTag)
  end
end
