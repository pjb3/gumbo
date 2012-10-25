require 'eco'

module Gumbo
  class EcoFile < CompileToJavaScriptFile
    ext ".eco"

    def compile(src)
      "this.JST || (this.JST = {}); this.JST['#{name.sub(/.eco$/,'')}'] = #{Eco.compile(src)};"
    end
  end
end
