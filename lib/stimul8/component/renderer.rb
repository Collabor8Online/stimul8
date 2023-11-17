module Stimul8
  module Component
    module Renderer
      require "markaby"
      extend ActiveSupport::Concern

      def to_html
        Markaby::Builder.new(assigns, &self.class.template_block).to_s
      end

      class_methods do
        def template &block
          @template_block = block
        end

        attr_reader :template_block
      end

      protected

      def assigns
        @assigns ||= instance_variables.each_with_object({}) do |var, assigns|
          assigns[var.to_s.delete("@")] = instance_variable_get(var)
        end
      end
    end
  end
end
