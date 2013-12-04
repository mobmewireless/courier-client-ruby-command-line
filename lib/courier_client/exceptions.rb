module CourierClient
  module Exceptions
    class InvalidUsage < StandardError; end
    class ApiFailure < StandardError; end
    class ConfigurationMissing < StandardError; end
    class EmptyMessage < StandardError; end
    class EmptyDeviceName < StandardError; end
  end
end
