module Stimul8
  module Component
    module Models
      require "securerandom"
      extend ActiveSupport::Concern

      class_methods do
        def model name, class_name: nil
          class_name ||= name.to_s.classify
          property :"#{name}_id", type: Object

          define_method :"#{name}=" do |value|
            send(:"#{name}_id=", value&.id)
            models[name.to_sym] = value
          end

          define_method name.to_sym do
            models[name.to_sym] ||= class_name.constantize.find(send(:"#{name}_id"))
          end
        end
      end

      protected

      def models
        @models ||= {}
      end
    end
  end
end
