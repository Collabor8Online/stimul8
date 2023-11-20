module Stimul8
  module Component
    module Core
      require "markaby"
      extend ActiveSupport::Concern

      class_methods do
        def render_if &block
          @render_if_block = block
        end

        def template &block
          @template_block = block
        end

        def tag tag_name
          @tag_name = tag_name
        end

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

        def style selector, rule
          styles[selector.to_s] ||= []
          styles[selector.to_s] << rule.to_s
        end

        def styles
          @styles ||= {}
        end

        attr_reader :render_if_block
        attr_reader :template_block
        attr_reader :tag_name
      end

      def initialize context: nil, component_id: nil, attributes: {}, **properties, &contents
        @context = context
        @component_id = component_id
        @attributes = attributes
        @contents = contents
        properties.each do |key, value|
          send(:"#{key}=", value)
        end
      end

      def to_html
        return "" unless render?
        Markaby::Builder.new({}, self) do
          tag! tag_name, id: component_id, class: css_class, **expanded_attributes do
            instance_eval(&template)
          end
        end.to_s
      end

      def component_class
        @component_class ||= self.class.name.underscore.dasherize
      end

      def css_class
        [component_class, @attributes[:class]].compact.join(" ")
      end

      def template
        self.class.template_block
      end

      def contents
        @contents&.call.to_s
      end

      def context
        @context.freeze
      end

      def component(component_class, properties = {}, &contents) # standard:disable Style/ArgumentsForwarding
        Stimul8::Component.component(component_class, properties, &contents) # standard:disable Style/ArgumentsForwarding
      end
      alias_method :c, :component

      def tag_name
        @tag_name ||= self.class.tag_name || :div
      end

      def stylesheet
        return @stylesheet unless @stylesheet.blank?
        @stylesheet = self.class.styles.map do |selector, rules|
          selection_rule = ".#{component_class} #{selector} {\n"
          rules.each do |rule|
            selection_rule += "  #{rule}\n"
          end
          selection_rule += "}"
          selection_rule
        end.join("\n")
      end

      def expanded_attributes
        return @expanded_attributes unless @expanded_attributes.nil?

        @expanded_attributes = @attributes.except(:class)
        @expanded_attributes[:data] ||= {}
        controller = ["stimul8", @expanded_attributes[:data][:controller]].compact.join(" ")
        @expanded_attributes[:data][:controller] = controller
        @expanded_attributes = @expanded_attributes.transform_keys do |key|
          key.to_s.dasherize.to_sym
        end
      end

      def render?
        self.class.render_if_block.nil? || instance_eval(&self.class.render_if_block)
      end
    end
  end
end
