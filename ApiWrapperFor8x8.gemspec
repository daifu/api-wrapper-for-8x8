# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/ApiWrapperFor8x8/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "ApiWrapperFor8x8"
  spec.version       = ApiWrapperFor8x8::VERSION
  spec.authors       = ["daifu"]
  spec.email         = ["daifu.ye@gmail.com"]
  spec.description   = %q{8x8 Phone System api wrapper to handle reporting.}
  spec.summary       = %q{8x8 Phone System api wrapper}
  spec.homepage      = "https://github.com/daifu/api-wrapper-for-8x8"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.11.0"
  spec.add_development_dependency "debugger"

  spec.add_dependency "bundler" , ">= 1.0.0"
  spec.add_dependency "httparty", ">= 0.9.0"
  spec.add_dependency "json"    , "~> 1.8.0"

end
