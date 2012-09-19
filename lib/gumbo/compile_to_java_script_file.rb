module Gumbo
  class CompileToJavaScriptFile < PackageFile
    def output_file
      @output_file ||= replace_ext(super, "js")
    end
  end
end
