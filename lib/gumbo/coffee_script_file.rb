require 'coffee_script'

module Gumbo
  class CoffeeScriptFile < CompileToJavaScriptFile
    ext ".coffee"
    compiler CoffeeScript
  end
end
