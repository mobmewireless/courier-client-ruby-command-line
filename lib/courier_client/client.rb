require_relative 'exceptions'
require_relative 'configuration'

module CourierClient
  class Client
    def configure(api_base_url, access_token)
      raise Exceptions::InvalidUsage if (api_base_url.nil? || access_token.nil?)

      configuration.store(
        api_base_url: api_base_url,
        access_token: access_token
      )
    end

    def send_message(message, device_name=nil)
      raise Exceptions::EmptyMessage if message.strip.empty?
      raise Exceptions::EmptyDeviceName if (!device_name.nil? && device_name.strip.empty?)

      response = RestClient.post api_route(device_name), { message: message, access_token: configuration.config[:access_token] }

      JSON.parse response
    end

    private

    def api_route(device_name=nil)
      device_segment = device_name ? "devices/#{device_name}" : ''
      File.join(configuration.config[:api_base_url], device_segment, 'messages')
    end

    def configuration
      CourierClient::Configuration.instance
    end
  end
end
