module Stimul8
  module ApplicationHelper
    def component(component_class, properties = {}, &contents)
      Stimul8::Component.component(name, **properties, &block)
    end
    alias_method :c, :component
  end
end
