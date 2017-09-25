# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmatters-sensu'

Gem::Specification.new do |s|
  s.name          = 'sensu-plugins-xmatters'
  s.version       = XMSensu::Version::VER_STRING
  s.authors       = ['xMatters', 'Dan Reich']
  s.email         = ['alderaan@xmatters.com', 'dreich@xmatters.com']

  s.summary       = 'A Sensu plugin for xMatters'
  s.description   = 'Provides a default xMatters handler and library that ' \
                      'can be used to create xMatters Events when events occur in ' \
                      'Sensu'
  s.homepage      = 'https://github.com/xmatters/sensu-plugins-xmatters'
  s.license       = 'MIT'
  s.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)

  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  s.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'sensu-plugin', '~> 1.4'

  s.add_development_dependency 'bundler', '~> 1.14'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rubocop', '~> 0.40.0'
  s.add_development_dependency 'webmock', '~> 2.3'
  s.add_development_dependency 'colorize', '~> 0.8'
  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'github-markup', '~> 1.3'
  s.add_development_dependency 'redcarpet', '~> 3.2'
end
