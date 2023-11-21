module Stimul8
  module Component
    module Storage
      extend ActiveSupport::Concern

      class << self
        def storage_engine
          @@storage_engine ||= Stimul8::Storage::InMemory.new
        end
      end

      protected

      def write property_name, value
        storage_engine.write component_id, property_name, value
      end

      def read property_name
        storage_engine.read component_id, property_name
      end

      def storage_engine
        Stimul8::Component::Storage.storage_engine
      end
    end
  end
end
