# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/dynamodb/version'

Gem::Specification.new do |spec|
  spec.name          = "rom-dynamodb"
  spec.version       = ROM::DynamoDB::VERSION
  spec.authors       = ["davidkelley"]
  spec.email         = ["david.james.kelley@gmail.com"]
  spec.summary       = 'DynamoDB adapter for Ruby Object Mapper'
  spec.homepage      = "https://github.com/davidkelley/rom-dynamo"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rom", '~> 5.3'
  spec.add_runtime_dependency "aws-sdk-dynamodb", '~> 1.84'
  spec.add_runtime_dependency "deep_merge", '~> 1.2.2'

  spec.add_development_dependency "json", '~> 2.6.3'
  spec.add_development_dependency "rake", '~> 13.0.6'
  spec.add_development_dependency "rspec", '~> 3.12.0'
  spec.add_development_dependency "yard", '~> 0.9.34'
  spec.add_development_dependency "redcarpet", '~> 3.6.0'
  spec.add_development_dependency "simplecov", '~> 0.22.0'
  spec.add_development_dependency "factory_bot", '~> 6.2.1'
  spec.add_development_dependency "faker", '~> 3.2.0'
  spec.add_development_dependency "pry", '~> 0.14.2'
end
