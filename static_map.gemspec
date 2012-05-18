# -*- encoding: utf-8 -*-
require File.expand_path('../lib/static_map/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Behan"]
  gem.email         = ["inbox@seanbehan.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "static_map"
  gem.require_paths = ["lib"]
  gem.version       = StaticMap::VERSION
end
