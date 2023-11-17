module Stimul8
  module Component
    module Properties
      extend ActiveSupport::Concern
      class_methods do
        def property name, type: String, nil: true, &validator
          define_method name.to_sym do
            instance_variable_get("@#{name}")
          end

          define_method :"#{name}=" do |value|
            raise ArgumentError.new("#{name} must be a #{type}") unless value.is_a?(type)
            raise ArgumentError.new("#{value} is not a valid value for #{name}") if validator && !validator.call(value)
            instance_variable_set("@#{name}", value)
          end
        end
      end

      def initialize **params
        params.each do |key, value|
          send(:"#{key}=", value)
        end
      end
    end
  end
end
