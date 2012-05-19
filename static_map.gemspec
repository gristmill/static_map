# -*- encoding: utf-8 -*-
require File.expand_path('../lib/static_map/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Behan"]
  gem.email         = ["inbox@seanbehan.com"]
  gem.description   = %q{Google Static Map API with Ruby}
  gem.summary       = %q{Build static maps using Google's Static Map API}
  gem.homepage      = "http://github.com/gristmill/static_map"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "static_map"
  gem.require_paths = ["lib"]
  gem.version       = StaticMap::VERSION
end
