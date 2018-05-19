
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chordpro/version'

Gem::Specification.new do |spec|
  spec.name          = 'chordpro'
  spec.version       = Chordpro::VERSION
  spec.authors       = ['Brandon Keepers']
  spec.email         = ['brandon@opensoul.org']
  spec.summary       = 'A ruby parser for the chordpro song file format.'
  spec.description   = 'A ruby parser for the chordpro song file format.'
  spec.homepage      = 'https://github.com/bkeepers/chordpro'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'builder'
  spec.add_dependency 'parslet'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
