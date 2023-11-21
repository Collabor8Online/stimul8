module Stimul8
  module Component
    module Create
      extend ActiveSupport::Concern

      def initialize context: nil, component_id: nil, attributes: {}, **properties, &contents
        @context = context
        @component_id = component_id
        @attributes = attributes
        @contents = contents
        properties.each do |key, value|
          send(:"#{key}=", value)
        end
      end
    end
  end
end
