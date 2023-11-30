module Stimul8
  module Component
    extend ActiveSupport::Concern
    require "stimul8/component/storage"
    require "stimul8/component/core"
    require "stimul8/component/models"
    require "stimul8/component/actions"
    require "stimul8/component/create"

    included do
      include Stimul8::Component::Storage
      include Stimul8::Component::Core
      include Stimul8::Component::Models
      include Stimul8::Component::Actions
      include Stimul8::Component::Create
    end

    class << self
      def recreate component_class, component_id, context: nil
        component_class.constantize.new(component_id: component_id, context: context)
      end

      def component(component_class, properties = {}, &contents)
        component_class = "#{component_class.to_s.classify}Component"
        component = component_class.constantize.new(**properties, &contents)
        component.to_html.html_safe
      end

      def erb_load_paths
        @erb_load_paths ||= Set.new
      end

      def add_erb_load_path path
        erb_load_paths.add path
      end

      alias_method :c, :component
    end

    class NotFound < Stimul8::Error
    end

    class ErbTemplateNotFound < NotFound
    end
  end
end
