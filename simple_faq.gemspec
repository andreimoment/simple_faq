# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_faq/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_faq"
  spec.version       = SimpleFAQ::VERSION
  spec.authors       = ["Andrei Andreev"]
  spec.email         = ["aaandre@gmail.com"]
  spec.summary       = %q{Easily create FAQ documents using Markdown and a few specilaized tags.}
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/andreimoment/simple_faq"
  spec.license       = "MIT"

  # spec.files         = `git ls-files -z`.split("\x0")
  spec.files = Dir["{lib,app}/**/*"] + ["LICENSE.txt", "README.md"]

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", "~> 4.2"

  spec.add_runtime_dependency "redcarpet"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
