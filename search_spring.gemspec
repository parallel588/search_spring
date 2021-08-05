# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search_spring/version'

Gem::Specification.new do |spec|
  spec.name          = 'search_spring'
  spec.version       = SearchSpring::VERSION
  spec.authors       = ['Maxim Pechnikov']
  spec.email         = ['parallel588@gmail.com']
  spec.summary     = 'You heard us, a Ruby wrapper for the SearchSpring Live Indexing API'
  spec.description = 'Ruby wrapper for the SearchSpring Live Indexing API'
  spec.homepage      = 'https://searchspring.com/'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'excon', '~> 0.85'
  spec.add_runtime_dependency 'faraday', '~> 1.6.0'
  spec.add_runtime_dependency 'multi_json', '~> 1.12', '>= 1.12.1'

  spec.add_development_dependency 'bundler', '~> 2.2.10'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'pry', '~> 0.10.3'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
