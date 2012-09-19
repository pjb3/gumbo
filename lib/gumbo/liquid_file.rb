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
      def initialize(tag_name, max, tokens)
         super
         @max = max.to_i
      end

      def render(context)
        "TODO"
      end
    end

    Liquid::Template.register_tag("asset_package", AssetPackageTag)
  end
end
