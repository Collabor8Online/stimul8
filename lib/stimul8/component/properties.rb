module Stimul8
  module Component
    module Properties
      extend ActiveSupport::Concern
      class_methods do
        def property name, type: :string, nil: true, default: nil, &validator
          properties << name.to_sym

          define_method name.to_sym do
            read(component_id, name) || default
          end

          if type != :boolean
            type_class = type.to_s.classify.constantize

            define_method :"#{name}=" do |value|
              raise ArgumentError.new("#{name} must be a #{type}") unless value.is_a?(type_class)
              raise ArgumentError.new("#{value} is not a valid value for #{name}") if validator && !validator.call(value)
              write component_id, name, value
            end
          else
            define_method :"#{name}?" do
              (send(name.to_sym) == true)
            end

            define_method :"#{name}=" do |value|
              write component_id, name, ActiveRecord::Type::Boolean.new.cast(value)
            end
          end
        end

        def properties
          @properties ||= Set.new
        end
      end

      def initialize component_id: nil, attributes: {}, **params
        @component_id = component_id
        @attributes = attributes
        params.each do |key, value|
          send(:"#{key}=", value)
        end
      end
    end
  end
end
