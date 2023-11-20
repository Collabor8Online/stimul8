module Stimul8
  module Component
    extend ActiveSupport::Concern
    require "stimul8/component/storage"
    require "stimul8/component/core"
    require "stimul8/component/models"
    require "stimul8/component/actions"

    included do
      include Stimul8::Component::Storage
      include Stimul8::Component::Core
      include Stimul8::Component::Models
      include Stimul8::Component::Actions
    end

    class_methods do
      def recreate component_id, context: nil
        new(component_id: component_id, context: context)
      end
    end

    class << self
      def component(component_class, properties = {}, &contents)
        component_class = "#{component_class.to_s.classify}Component"
        component = component_class.constantize.new(**properties, &contents)
        component.to_html.html_safe
      end

      alias_method :c, :component
    end
  end
end
