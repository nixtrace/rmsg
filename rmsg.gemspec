# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rmsg/version'

Gem::Specification.new do |spec|
  spec.name          = "rmsg"
  spec.version       = Rmsg::VERSION
  spec.authors       = ["badshark"]
  spec.email         = ["marco@badshark.io"]
  spec.summary       = %q{RabbitMQ messaging.}
  spec.description   = %q{RabbitMQ messaging with topics and tasks. A thin, minimal layer on top of Bunny.}
  spec.homepage      = "https://github.com/badshark/rmsg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "bunny", "~> 1.6"
  spec.add_dependency "json", "~> 1.8.1"
end
