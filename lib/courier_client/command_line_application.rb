# Gems
require 'commander/import'

# Local
require_relative 'version'
require_relative 'client'

program :name, 'Courier Client'
program :version, CourierClient.version.to_s
program :description, 'Command line client for the Courier application suite.'

courier_client = CourierClient::Client.new

command :config do |c|
  c.syntax = 'courier config API_BASE_URL ACCESS_TOKEN'
  c.description = 'Stores configuration used to contact and authenticate with the Courier server'

  c.action do |args, opts|
    begin
      courier_client.configure args[0], args[1]
    rescue CourierClient::Exceptions::InvalidUsage
      say "Invalid usage. Please check how to use this command with 'courier --help config'."
    end
  end
end

command :send  do |c|
  c.syntax = "courier send 'UTF-8 message' [options]"
  c.description = 'Sends a message to all your devices, or to selected device.'
  c.option '--device DEVICE_NAME', String, 'Sends message to device with supplied name.'

  c.action do |args, opts|
    begin
      say courier_client.send_message(args[0], opts.device).inspect
    rescue CourierClient::Exceptions::ApiFailure => e
      say "The courier server rejected the request with the following reason: '#{e.message}'"
    rescue CourierClient::Exceptions::ConfigurationMissing
      say "Courier client hasn't been configured yet. Please use the 'courier config' command before attempting to send messages."
    end
  end
end
