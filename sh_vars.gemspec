# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)
require 'sh_vars/version'

Gem::Specification.new do |s|
  s.name         = 'sh_vars'
  s.version      = ShVars::VERSION
  s.summary      = 'Shell var parser'
  s.description  = 'Shell var parser.'
  s.authors      = ['Sven Fuchs', 'Joe Corcoran']
  s.email        = ['me@svenfuchs.com', 'joe@corcoran.online']
  s.homepage     = 'https://github.com/svenfuchs/sh_vars'
  s.licenses     = ['MIT']

  s.files        = Dir.glob('{examples/**/*,lib/**/*,[A-Z]*}')
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.add_development_dependency 'rspec', '~> 3.0'
end
