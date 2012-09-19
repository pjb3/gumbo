# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gumbo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Barry"]
  gem.email         = ["mail@paulbarry.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gumbo"
  gem.require_paths = ["lib"]
  gem.version       = Gumbo::VERSION

  gem.add_runtime_dependency "coffee-script", "~> 2.2.0"
  gem.add_runtime_dependency "liquid", "~> 2.4.1"
end
