module Stimul8
  module Storage
    class InMemory
      include Stimul8::Storage

      def initialize
        @components = {}
      end

      def write component_id, property_name, value
        @components[key_for(component_id, property_name)] = value
      end

      def read component_id, property_name
        @components[key_for(component_id, property_name)]
      end
    end
  end
end
