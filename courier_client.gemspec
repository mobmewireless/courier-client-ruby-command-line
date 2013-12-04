lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'courier_client/version'

Gem::Specification.new do |s|
  s.name     = 'courier_client'
  s.version  = CourierClient.version
  s.executables << 'courier'
  s.platform = Gem::Platform::RUBY

  s.author             = 'MobME'
  s.email              = 'engineering@mobme.in'
  s.homepage           = 'http://42.mobme.in/'
  s.summary            = 'Command line client for the Courier application suite.'
  s.description        = "Provides a command line client for Courier, allowing messages to be sent from the command line to a Android user's mobile phone."
  s.license            = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakefs'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'faker'

  s.add_dependency 'activesupport'
  s.add_dependency 'commander'
  s.add_dependency 'rest-client'

  s.files              = `git ls-files`.split("\n") - %w(Gemfile.lock .ruby-version)
  s.test_files         = `git ls-files -- spec/*`.split("\n")
  s.require_paths      = %w(lib)
end
