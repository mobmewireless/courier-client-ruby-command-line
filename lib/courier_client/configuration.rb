require 'singleton'
require_relative 'exceptions'

module CourierClient
  class Configuration
    include Singleton

    CONFIG_DIRECTORY_PATH = File.expand_path '~/.courier'
    CONFIG_FILE_PATH = File.join CONFIG_DIRECTORY_PATH, 'config.yml'

    def config
      @config ||= begin
        YAML.load_file(Configuration::CONFIG_FILE_PATH).with_indifferent_access
      rescue Errno::ENOENT
        raise CourierClient::Exceptions::ConfigurationMissing
      end

      @config
    end

    def store(configuration)
      begin
        File.open(Configuration::CONFIG_FILE_PATH, 'w') do |f|
          YAML.dump(configuration, f)
        end
      rescue Errno::ENOENT
        Dir.mkdir(CONFIG_DIRECTORY_PATH)

        retry
      end

      configuration.with_indifferent_access
    end
  end
end
