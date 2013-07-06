# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cryptic/version'

Gem::Specification.new do |spec|
  spec.name          = 'cryptic'
  spec.version       = Cryptic::VERSION
  spec.authors       = ['Erran Carey']
  spec.email         = ['me@errancarey.com']
  spec.description   = 'A gem to encrypt data using public keys.'
  spec.summary       = 'A quick way to encrypt data using public keys. Only people with the private key can decrypt said data.'
  spec.homepage      = 'https://github.com/ipwnstuff/cryptic'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'redcarpet'
  spec.add_dependency 'thor'
  spec.add_dependency 'yard'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
