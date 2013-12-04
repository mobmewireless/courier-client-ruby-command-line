# Standard
require 'fileutils'

# Local
require 'courier_client'

# Gems
require 'rspec'
require 'webmock/rspec'
require 'faker'
require 'fakefs/safe' # Fake File System

# Disable real network requests when testing.
WebMock.disable_net_connect!
