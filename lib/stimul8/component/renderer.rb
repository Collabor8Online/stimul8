module Stimul8
  module Component
    module Renderer
      require "markaby"
      extend ActiveSupport::Concern

      def to_html
        Markaby::Builder.new({}, self) do
          tag! tag_name, class: css_class, id: component_id do
            instance_eval(&template)
          end
        end.to_s
      end

      def css_class
        self.class.name.underscore.dasherize
      end

      def template
        self.class.template_block
      end

      def tag_name
        self.class.tag_name || :div
      end

      class_methods do
        def template &block
          @template_block = block
        end

        def tag tag_name
          @tag_name = tag_name
        end

        attr_reader :template_block
        attr_reader :tag_name
      end
    end
  end
end
