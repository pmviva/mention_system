# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mention_system/version'

Gem::Specification.new do |spec|
  spec.name          = "mention_system"
  spec.version       = MentionSystem::VERSION
  spec.authors       = ["Pablo Martin Viva"]
  spec.email         = ["pmviva@gmail.com"]
  spec.summary       = %q{An active record like system.}
  spec.description   = %q{An active record mention system developed using ruby on rails 4.1 applying domain driven design and test driven development principles.}
  spec.homepage      = "http://github.com/pmviva/mention_system"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_dependency "rails", [ ">= 4.1", "< 5.2" ]

  spec.add_development_dependency "appraisal", "~> 2.1"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "shoulda-matchers", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "yard", "~> 0.8"
end

