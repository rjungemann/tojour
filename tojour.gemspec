# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tojour/version'

Gem::Specification.new do |spec|
  spec.name          = 'tojour'
  spec.version       = Tojour::VERSION
  spec.authors       = ['Roger Jungemann']
  spec.email         = ['roger@thefifthcircuit.com']

  spec.summary       = %q{Like AirDrop for the command line.}
  spec.homepage      = 'https://github.com/rjungemann/tojour'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dnssd', '~> 3.0.1'
  spec.add_dependency 'colorize', '~> 0.7.7'
  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
end
