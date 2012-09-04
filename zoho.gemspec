# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zoho/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Victor Raj"]
  gem.email         = ["paulvictor@gmail.com"]
  gem.description   = %q{Ruby interface to ZOHO docs}
  gem.summary       = %q{Ruby interface to ZOHO docs}
  gem.homepage      = "git://github.com/paulvictor/zoho.git"

  gem.add_dependency "rest-client", "~> 1.6.7"
  gem.add_development_dependency "rspec", "~> 2.11.0"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zoho"
  gem.require_paths = ["lib"]
  gem.version       = Zoho::VERSION
end
