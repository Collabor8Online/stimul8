module Stimul8
  module Component
    module Storage
      extend ActiveSupport::Concern

      class_methods do
        def storage_engine
          @@storage_engine ||= Stimul8::Storage::InMemory.new
        end
      end

      protected

      def write component_id, property_name, value
        storage_engine.write component_id, property_name, value
      end

      def read component_id, property_name
        storage_engine.read component_id, property_name
      end

      def storage_engine
        self.class.storage_engine
      end
    end
  end
end
