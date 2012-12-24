# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'router_simple/version'

Gem::Specification.new do |gem|
  gem.name          = "router_simple"
  gem.version       = RouterSimple::VERSION
  gem.authors       = ["tokuhirom"]
  gem.email         = ["tokuhirom@gmail.com"]
  gem.description   = %q{Simple HTTP routing library}
  gem.summary       = %q{Yet another http routing library}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest"  
end

