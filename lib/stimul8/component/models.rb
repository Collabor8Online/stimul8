module Stimul8
  module Component
    module Models
      require "base64"
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

        def recreate component_id
          decoded = JSON.parse(Base64.urlsafe_decode64(component_id))
          ids = decoded.transform_keys { |key| key.to_sym }
          new(**ids)
        end
      end

      def component_id
        Base64.urlsafe_encode64(model_ids.to_json)
      end

      def model_ids
        models.to_h do |name, model|
          [:"#{name}_id", model.id]
        end
      end

      protected

      def models
        @models ||= {}
      end
    end
  end
end
